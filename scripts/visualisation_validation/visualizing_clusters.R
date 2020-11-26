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
SHAPE_DIR = paste0('../../', 'data/', 'shapefiles')
CLUSTER_DIR = paste0("visualisation_validation/", "cluster_labels")


# reading in the geojson file for simple feature collection and additional fields

i = 1
for (munic in MUNICIPALITIES){
  if (i == 1){
    shp = sf::st_read(paste0("../../shapefile/", munic, "/", munic, "_shp.json"))
    shp$Munic = munic
  }
  else{
  munic_shp = sf::st_read(paste0("../shapefile/", munic, "/", munic, "_shp.json"))
  munic_shp$Munic = munic
  shp = rbind(shp, munic_shp)
  }

  i = i+1

}

plot(shp[,"Munic"], main="", key.pos=4, key.width = lcm(5.4))


cluster_file_name = "HDBSCAN_clusters_UMAP.csv"
# reading in clusters assigned to each ward
df_clusters = read.csv(paste0('./clusters/', cluster_file_name))
df_clusters$Cluster = as.factor(df_clusters$Cluster)
str(df_clusters)



for (munic in MUNICIPALITIES){
  shp[which(shp$Munic== munic), 'cluster'] = df_clusters[which(df_clusters$Municipality == munic), 'Cluster']
}




# pdf(paste0('./clusters/', cluster_f, ".pdf"))
plot(shp[, 'cluster'], main=cluster_f)
# dev.off()


mapKey <- "AIzaSyDLoj9wkzUiTr2TYsyCYphA6Nu1pDJIFnU"

google_map(key = mapKey) %>%
  add_polygons(data = shp, polyline = "geometry", stroke_opacity = 0.5, fill_opacity = 0.5, fill_colour = 'Munic', legend=T)








