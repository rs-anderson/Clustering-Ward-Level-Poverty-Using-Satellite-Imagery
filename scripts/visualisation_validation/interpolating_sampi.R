################## Interpolating SAMPI###################
# this script interpolates the missing sampi-values using
# inverse distance weighting
# Broadly, the steps to interpolate the missing values are:
## 1. Set working directories and read in data files and packages
## 2. Find the missing values:
### 2a.) First find how many wards each muni should have
### 2b.) Then find which have less than specified
### 2c.) Create a dataframe with missing wards per muni
## 3. Read in the shape files per municipality
## 4. Impute missing SAMPI values with IDW


####### 1. ##########
rm(list=ls())
# load packages:
library(readxl)
library(tidyr)
pacman::p_load(skimr, sf, sp, geoR,  gstat, stars, automap, intamap,  tidyverse,tmap, tmaptools, spData, rgdal, raster, maptools, GGally)
library(spatstat)
library (maptools)
library(fields)
library(spdep)
library(sf)


# set working directory
current_path <- rstudioapi::getActiveDocumentContext()$path
setwd(dirname(current_path))

# define paths for later
FEATURES_DIR <- paste0("../../","data/","extracted_features/","all_features.csv")
SAMPI_DIR <- paste0("../../","data/","SAMPI by Province, District, Municipality & Ward.xls")

# load features
features <- read.csv(FEATURES_DIR)
# drop first column
features <- features[,-1]

# read in sampi data
df_SAMPI = read_excel(SAMPI_DIR,skip=1)
# remove first two rows and columns
df_SAMPI_edit <- df_SAMPI[-c(1,2),-c(1,2)]


####### 2. ########
# find rows with district and municipality values (Not NA's)
# (these are rows without SAMPI values and need to be removed)
new_district <- which(df_SAMPI_edit$DISTRICT!= is.na(df_SAMPI_edit$DISTRICT))
new_muni <- which(df_SAMPI_edit$MUNICIPALITY!= is.na(df_SAMPI_edit$MUNICIPALITY))

# all indices to remove:
remove_index <- c(1:2, sort(c(new_district,new_muni))+2) # add 2 rows for deleted rows

# fill down column entries
df_SAMPI = df_SAMPI %>% fill(names(df_SAMPI))
sampi <- df_SAMPI[-remove_index,c(3,5,8,9,12,15)] 


### 2a. ###
# find names of all the municipalities
muni <- as.vector(unique(df_SAMPI$MUNICIPALITY))
muni <- muni[2:11] # unique municipalities

# now identify missing ward no's:

wards_sampi <- c() # how many wards in each muni for sampi data
wards_features <- c() # how many wards in each muni for all_features.csv
# count number of wards for each muni
for (i in 1:length(muni)){
  wards_sampi[i] <- length(which(sampi$MUNICIPALITY==muni[i]))
  wards_features[i] <- length(which(features$Municipality==muni[i]))
}

sum(wards_features) # 508 wards (correct number of wards)
sum(wards_sampi) # 497 wards, thus 11 missing

### 2b. ###
# find the municipalities with missing wards:
muni_missing_wards <- muni[which(wards_features!=wards_sampi)]

# how many wards each municipality should have:
actual_wards <- wards_features[which(wards_features!=wards_sampi)]

### 2c. ###
# create a data frame to id missing ward numbers:
missing_wards_per_muni <- data.frame(muni_missing_wards)
missing_wards_per_muni <- cbind(missing_wards_per_muni,NA,NA)

# there are at most 2 missing values from one single ward
# to find the ward number for each municipality missing a value
# we use the following loop:
for (i in 1:length(muni_missing_wards)){
  # create a sequence of what the ward numbers should be:
  actual_seq <- 1:actual_wards[i]
  # see which numbers are missing from that sequence:
  different <- setdiff(actual_seq,t(sampi[sampi$MUNICIPALITY==muni_missing_wards[i],"WARDNO"]))
  if(length(different)==1){
    # "different" is the ward no that is missing, put this into a dataframe:
    missing_wards_per_muni[i,2] <- different
  }
  else(missing_wards_per_muni[i,2:3] <- different)
}


####### 3. #######


# Reading in Shape File
# list of municipalities to define ordering
MUNICIPALITIES = c(
  'Emfuleni',
  'Merafong City',
  'Midvaal',
  'Lesedi',
  'Mogale City',
  'Ekurhuleni',
  'Randfontein',
  'Westonaria',
  'City of Tshwane',
  'City of Johannesburg'
)

# stacking the shape files for the individual municipalities
i = 1
for (munic in MUNICIPALITIES){
  if (i == 1){
    shp = sf::st_read(paste0("../../data/shapefiles/", munic, "/", munic, "_shp.json"))
    shp$Munic = munic
  }
  else{
    munic_shp = sf::st_read(paste0("../../data/shapefiles/", munic, "/", munic, "_shp.json"))
    munic_shp$Munic = munic
    shp = rbind(shp, munic_shp)
  }
  
  i = i+1
  
}

# check that it worked
plot(shp[,"Munic"])


####### 4. #######

# create a row of NA's for each missing ward:
for (i in 1:nrow(missing_wards_per_muni)){
  (municipality = missing_wards_per_muni[i, 1])
  (ward_number_1 = missing_wards_per_muni[i, 2])
  print(sampi[which(sampi$MUNICIPALITY == municipality & sampi$WARDNO == ward_number_1),])
  
  ind = which(sampi$MUNICIPALITY == municipality & sampi$WARDNO == ward_number_1-1)
  sampi = rbind(sampi[1:ind,], c(NA, municipality, ward_number_1, NA, NA, NA), sampi[(ind+1):nrow(sampi),])
  print(sampi[ind:(ind+2),])
  
  (ward_number_2 = missing_wards_per_muni[i, 3])
  
  if (!is.na(ward_number_2)){
    ind = which(sampi$MUNICIPALITY == municipality & sampi$WARDNO == ward_number_2-1)
    sampi = rbind(sampi[1:ind,], c(NA, municipality, ward_number_2, NA, NA, NA), sampi[(ind+1):nrow(sampi),])
    print(sampi[ind:(ind+2),])

  }
}

# ordering the SAMPI values to be the same as all_features
i = 1
for (munic in MUNICIPALITIES){
  if (i == 1){
      sampi_ordered = sampi[which(sampi$MUNICIPALITY==munic),]
  }
  else{
    sampi_ordered = rbind(sampi_ordered, sampi[which(sampi$MUNICIPALITY==munic),])
  }
  
  i = i+1
  
}

coords <- st_coordinates(st_centroid(st_geometry(shp)))

# create a spatial dataframe:
spat_df = data.frame(x = coords[, "X"], y = coords[, "Y"], ward_no. = shp$WardNumber, Municipality = as.factor(shp$Munic),
                     sampi = sampi_ordered$sampi...15)
coordinates(spat_df) <- c("x", "y") # tells r to use x and y columns as the lat/long 
proj4string(spat_df) <- CRS("+init=epsg:28992") # Set projection
# str(spat_df)


# idw with power of 4
idw_4 <- gstat::idw(sampi ~ 1, spat_df[which(!is.na(spat_df$sampi)),], newdata=spat_df[which(is.na(spat_df$sampi)),], idp=4)$var1.pred

# fill in missing values with imputed values
spat_df[which(is.na(spat_df$sampi)), "sampi"] = idw_4 

# merge the sampi values with feature set
df_final = merge(spat_df, features, by = c("Municipality", "ward_no."))
df_final = as.data.frame(df_final)

# write to csv file
write.csv(df_final, 'final_data.csv')


