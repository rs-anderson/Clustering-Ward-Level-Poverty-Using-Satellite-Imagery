
# Description -------------------------------------------------------------

# This script is for the visualization of the cluster solutions obtained.
# Furthermore, googleway can be used to navigate the map of Gauteng
# to investigate the specific areas within each cluster.



# Packages Used -----------------------------------------------------------


library(sf)
library(googleway)
library(googlePolylines)
library(ggplot2)
library(gridExtra)
library(rstudioapi)


# defining the municipality names
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


# setting working directory to source file location
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))

# defining paths for later
SHAPE_DIR = paste0('../../', 'data/', 'shapefiles/')
CLUSTER_DIR = paste0("./", "cluster_labels/")


# reading in each municipality's geojson shapefile and combining them

i = 1
for (munic in MUNICIPALITIES){
  if (i == 1){
    shp = sf::st_read(paste0(SHAPE_DIR, munic, "/", munic, "_shp.json"))
    shp$Munic = munic
    i = i+1
  }
  else{
    munic_shp = sf::st_read(paste0(SHAPE_DIR, munic, "/", munic, "_shp.json"))
    munic_shp$Munic = munic
    shp = rbind(shp, munic_shp)
  }
}

# map of Gauteng wards, coloured by municipality
plot(shp[, "Munic"], main="", key.pos=4, key.width = lcm(5.4))


# name of cluster file
cluster_file_name = "HDBSCAN_clusters_18.csv"

# reading in clusters assigned to each ward
df_clusters = read.csv(paste0(CLUSTER_DIR, cluster_file_name))
df_clusters$Cluster = as.factor(df_clusters$Cluster)
str(df_clusters)


# adding the cluster allocations to the sf object
for (munic in MUNICIPALITIES){
  shp[which(shp$Munic== munic), 'cluster'] = df_clusters[which(df_clusters$Municipality == munic), 'Cluster']
}


# visualizing clusters on map of Gauteng
plot(shp[, 'cluster'])


# use googleway to visualize clusters on interactive Google map
mapKey <- "YOUR_API_KEY"

google_map(key = mapKey) %>%
  add_polygons(data = shp, polyline = "geometry", stroke_opacity = 0.5, fill_opacity = 0.5, fill_colour = 'cluster', legend=T)








