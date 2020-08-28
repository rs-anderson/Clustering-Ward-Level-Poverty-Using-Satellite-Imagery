library(googlePolylines)
library(sf)
library(googleway)

gau = sf::st_read("./City of Johannesburg_shp.json")
str(gau)

# nwards = 130
# gau[1,]$geometry

# enc = encode(gau, strip=TRUE)
# enc[1,]$geometry
# str(enc)
# 
# enc[,"geometry"][[1]][1]
# 
# for (i in 1:130){
#   enc[,"geometry"][[i]][1]
# }


mapKey <- "AIzaSyDLoj9wkzUiTr2TYsyCYphA6Nu1pDJIFnU"

google_map(key = mapKey) %>%
  add_polygons(data = gau[11,], polyline = "geometry", fill_colour = "#00FF00", fill_opacity = 1, stroke_colour="#00FF00")


# google_map(key = mapKey) %>%
#   add_polygons(data = enc[1,], polyline = "geometry", fill_colour = "#00FF00", fill_opacity = 0.2)


raw_points = unlist(gau[11,]$geometry)
y_raw = raw_points[which(raw_points<0)]
x_raw = raw_points[-which(raw_points<0)]


## Example: 

# https://maps.googleapis.com/maps/api/staticmap?center=-26.491,27.842&zoom=16&size=400x400&scale=2&maptype=satellite&path=fillcolor:0xAA000033%7Ccolor:0xFFFFFF00%7Cenc:pys`Dsp|hDfFmFMMu@_AaDC?}AA}A?uF@eEAuCuME?cAFABqK_E?_@Om@a@^aA^aAbAaCF_@?k@?qBeMC?uAGQ@iA@cE@}A@O@cAEM@eEBK?mACECE?gAB??k@lDAf@AVCRMx@_B|@kBVJVLb@XJBnBE`@IvBcLdDQr@G`@ERE^MZQfB{A^]X_@P[ZeAVmApBkJ^iBbBeIjAqF`@gBf@{BpBoNd@gDFc@Hk@Ja@HYHYR_@R[RWNSRQVQVOXMj@SzDeAvA_@fBa@rBc@LCtAU~AWjC_@rViDD^`@hDpBpS|AxNJ`AFz@@r@@v@ApAAj@CVCXCRETIVe@zAcEdNPF|Al@|CjAjEbBpFvBp@V\\N\\RZRXRRLTR`@\\HHPP|CbDjCpCKJi@n@{DnE_DnDuFnGA@i@j@iBbCgAtAoBvD{N~[u@|AGNsPd_@qUfh@|@|@fy@|\\z@\\vWvKPHwDVel@~DidAbHe`@nCq@oEyAuHn\\acAJ[BIHUlB{F~@wC&key=AIzaSyDLoj9wkzUiTr2TYsyCYphA6Nu1pDJIFnU

center = c(-26.50166500199998, 28.18376999700007)
y_rad = 0.00385
x_rad = 0.0043

y1 = -26.491 + y_rad
y2 = -26.491 - y_rad
x1 = 27.842 + x_rad
x2 = 27.842 - x_rad


df_ward = data.frame("Lat" = y_raw,"Lon" = x_raw, id=1, path_id=1, colour = "#00FF0F")

# Lon are the "x" values, Lat are the "y" values
# df_rectangles = data.frame("Lat" = c(-26.491,-26.489,-26.489, -26.491),"Lon" = c(27.84, 27.84, 27.842, 27.842), id=2, path_id=2, colour = "##FF00FF")
# df_ward_recs = rbind(df_ward, df_rectangles)
df_rectangles = data.frame("Lat" = c(y2,y1,y1,y2),"Lon" = c(x2, x2, x1, x1), id=2, path_id=2, colour = "#FF0000")
df_ward_recs = rbind(df_ward, df_rectangles)

google_map(key = mapKey) %>%
  add_polygons(data = df_ward_recs, lat="Lat", lon="Lon", id="id", pathId = "path_id", fill_colour = "colour", fill_opacity = 1, draggable = TRUE) # %>%

    
#################################################

########### Generating for all Wards ############

#################################################

df_ward_pics = data.frame("ward_number" = 1:nwards, "centers" = 0)

## 1/2 height of square
y_rad = 0.00385

## 1/2 width of square
x_rad = 0.0043

# WARD 1

raw_points = unlist(gau[1,]$geometry)
x_raw = raw_points[which(raw_points<0)]
y_raw = raw_points[-which(raw_points<0)]


# 1.

## y , x
center = c(-26.4946, 27.868)

y1 = center[1] + y_rad
y2 = center[1] - y_rad
x1 = center[2] + x_rad
x2 = center[2] - x_rad


df_ward = data.frame("Lat" = x_raw,"Lon" = y_raw, id=1, path_id=1, colour = "#00FF0F")

# Lon are the "x" values, Lat are the "y" values
df_rectangles = data.frame("Lat" = c(y2,y1,y1,y2),"Lon" = c(x2, x2, x1, x1), id=2, path_id=2, colour = "#FF0000")
df_ward_recs = rbind(df_ward, df_rectangles)

# 2.

## y , x
center = c(-26.4946+y_rad, 27.868-2*x_rad)

y1 = center[1] + y_rad
y2 = center[1] - y_rad
x1 = center[2] + x_rad
x2 = center[2] - x_rad

df_rectangles = data.frame("Lat" = c(y2,y1,y1,y2),"Lon" = c(x2, x2, x1, x1), id=2, path_id=3, colour = "#FF0000")
df_ward_recs = rbind(df_ward_recs, df_rectangles)

# 3.

## y , x
center = c(-26.4946-y_rad, 27.868-2*x_rad - 0.0023)

y1 = center[1] + y_rad
y2 = center[1] - y_rad
x1 = center[2] + x_rad
x2 = center[2] - x_rad

df_rectangles = data.frame("Lat" = c(y2,y1,y1,y2),"Lon" = c(x2, x2, x1, x1), id=2, path_id=4, colour = "#FF0000")
df_ward_recs = rbind(df_ward_recs, df_rectangles)

# 4.

## y , x
center = c(-26.4946+3*y_rad, 27.868-4*x_rad + 0.0023)

y1 = center[1] + y_rad
y2 = center[1] - y_rad
x1 = center[2] + x_rad
x2 = center[2] - x_rad

df_rectangles = data.frame("Lat" = c(y2,y1,y1,y2),"Lon" = c(x2, x2, x1, x1), id=2, path_id=5, colour = "#FF0000")
df_ward_recs = rbind(df_ward_recs, df_rectangles)

# 5.

## y , x
center = c(-26.4946+y_rad, 27.868-4*x_rad)

y1 = center[1] + y_rad
y2 = center[1] - y_rad
x1 = center[2] + x_rad
x2 = center[2] - x_rad

df_rectangles = data.frame("Lat" = c(y2,y1,y1,y2),"Lon" = c(x2, x2, x1, x1), id=2, path_id=6, colour = "#FF0000")
df_ward_recs = rbind(df_ward_recs, df_rectangles)

# 6.

## y , x
center = c(-26.4946+y_rad+0.002, 27.868-6*x_rad)

y1 = center[1] + y_rad
y2 = center[1] - y_rad
x1 = center[2] + x_rad
x2 = center[2] - x_rad

df_rectangles = data.frame("Lat" = c(y2,y1,y1,y2),"Lon" = c(x2, x2, x1, x1), id=2, path_id=7, colour = "#FF0000")
df_ward_recs = rbind(df_ward_recs, df_rectangles)

# 7.

## y , x
center = c(-26.4946+y_rad+0.006, 27.868-9*x_rad)

y1 = center[1] + y_rad
y2 = center[1] - y_rad
x1 = center[2] + x_rad
x2 = center[2] - x_rad

df_rectangles = data.frame("Lat" = c(y2,y1,y1,y2),"Lon" = c(x2, x2, x1, x1), id=2, path_id=8, colour = "#FF0000")
df_ward_recs = rbind(df_ward_recs, df_rectangles)

# 8.

## y , x
center = c(-26.4946+y_rad+0.006-2*y_rad, 27.868-9*x_rad + 0.00065)

y1 = center[1] + y_rad
y2 = center[1] - y_rad
x1 = center[2] + x_rad
x2 = center[2] - x_rad

df_rectangles = data.frame("Lat" = c(y2,y1,y1,y2),"Lon" = c(x2, x2, x1, x1), id=2, path_id=9, colour = "#FF0000")
df_ward_recs = rbind(df_ward_recs, df_rectangles)


google_map(key = mapKey) %>%
  add_polygons(data = df_ward_recs, lat="Lat", lon="Lon", id="id", pathId = "path_id", fill_colour = "colour", fill_opacity = 0.2)





##################################
##### Method to plot faster ######
##################################


## Define the centers for the rectangles (Lat, Lon) or (y, x)
centers = list()
centers[[1]] = c(-26.479878001999964, 27.824467997000056) 
# ([27.87418553400005, -26.498191678999945],
                                    # [27.824467997000056, -26.479878001999964])
centers[[2]] = c(-26.4946+y_rad, 27.868-2*x_rad)
centers[[3]] = c(-26.4946-y_rad, 27.868-2*x_rad - 0.0023)
centers[[4]] = c(-26.4946+3*y_rad, 27.868-4*x_rad + 0.0023)
centers[[5]] = c(-26.4946+y_rad, 27.868-4*x_rad)
centers[[6]] = c(-26.4946+y_rad+0.002, 27.868-6*x_rad)
centers[[7]] = c(-26.4946+y_rad+0.006, 27.868-9*x_rad)
centers[[8]] = c(-26.4946+y_rad+0.006-2*y_rad, 27.868-9*x_rad + 0.00065)

## Function for plotting the rectangles within the wards, with the rectangles centered at "centers"
ward_pics_plotter = function(centers, ward_no){
  
  ## Extract the ward shape
  raw_points = unlist(gau[ward_no,]$geometry)
  y_raw = raw_points[which(raw_points<0)]
  x_raw = raw_points[-which(raw_points<0)]
  
  ## For plotting entire ward shape
  df_ward = data.frame("Lat" = y_raw,"Lon" = x_raw, id=1, path_id=1, colour = "#00FF0F")
  
  df_ward_recs = data.frame(df_ward)
  
  for (i in 1:length(centers)){
    center = centers[[i]]            ## Specific center for rectangle of interest
    y1 = center[1] + y_rad           ## top y coordinate
    y2 = center[1] - y_rad           ## bottom y coordinate
    x1 = center[2] + x_rad           ## right x coordinate
    x2 = center[2] - x_rad           ## left x coordinate
    
    ## Storing the rectangle and then appending it to the ward shape data frame for plotting
    df_rectangles = data.frame("Lat" = c(y2,y1,y1,y2),"Lon" = c(x2, x2, x1, x1), id=i+1, path_id=i+1, colour = "#FF0000")
    df_ward_recs = rbind(df_ward_recs, df_rectangles)
  }
  
  ## Plotting the map with the shapes overlaid
  google_map(key = mapKey) %>%
    add_polygons(data = df_ward_recs[which(df_ward_recs$id==1),], lat="Lat", lon="Lon", id="id", pathId = "path_id", fill_colour = "colour", fill_opacity = 0.2) %>%
    add_polygons(data = df_ward_recs[-which(df_ward_recs$id==1),], lat="Lat", lon="Lon", id="id", pathId = "path_id", fill_colour = "colour", fill_opacity = 0.2, draggable = TRUE)
  
}

ward_pics_plotter(centers, 1)

