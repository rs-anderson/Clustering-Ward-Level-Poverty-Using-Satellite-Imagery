library(sf)
library(googleway)
library(googlePolylines)
library(ggplot2)
library(gridExtra)


# reading in the geojson file for simple feature collection and additional fields
gau = sf::st_read("./electoral wards for jhb.json")
str(gau)


# reading in clusters assigned to each ward
df_clusters = read.csv('cluster_example.csv')
df_clusters$Cluster = as.factor(df_clusters$Cluster)
str(df_clusters)

gau['cluster'] = df_clusters['Cluster']
str(gau)

plot(gau['cluster'])


mapKey <- "YOUR KEY"

google_map(key = mapKey) %>%
  add_polygons(data = gau, polyline = "geometry", fill_colour = 'cluster', fill_opacity = 0.9)


#####################################################

####################################################

names = c('cluster_2_35', 'cluster_9_35', 'cluster_11_5', 'cluster_13_20')

df = data.frame('Ward_no' = 1:130)

# reading in clusters assigned to each ward
df_clusters = read.csv('cluster2_pc35.csv')
df_clusters$Cluster = as.factor(df_clusters$Cluster)
df[names[1]] =  as.factor(df_clusters$Cluster)

gau['cluster_2_35'] = df_clusters['Cluster']


# reading in clusters assigned to each ward
df_clusters = read.csv('cluster9_pc35.csv')
df_clusters$Cluster = as.factor(df_clusters$Cluster)

df[names[2]] =  as.factor(df_clusters$Cluster)

gau['cluster_9_35'] = df_clusters['Cluster']


# reading in clusters assigned to each ward
df_clusters = read.csv('cluster11_pc5.csv')
df_clusters$Cluster = as.factor(df_clusters$Cluster)

gau['cluster_11_5'] = df_clusters['Cluster']

df[names[3]] =  as.factor(df_clusters$Cluster)


# reading in clusters assigned to each ward
df_clusters = read.csv('cluster13_pc20.csv')
df_clusters$Cluster = as.factor(df_clusters$Cluster)

gau['cluster_13_20'] = df_clusters['Cluster']

df[names[4]] =  as.factor(df_clusters$Cluster)

plot(gau[names])

p1 = ggplot() +
  geom_sf(data = gau, aes(fill = cluster_2_35))
p2 = ggplot() +
  geom_sf(data = gau, aes(fill = cluster_9_35))
p3 = ggplot() +
  geom_sf(data = gau, aes(fill = cluster_11_5))
p4 = ggplot() +
  geom_sf(data = gau, aes(fill = cluster_13_20))

grid.arrange(p1, p2, p3, p4, nrow = 2)

########################################################
########################################################

# reading in clusters assigned to each ward
df_clusters = read.csv('agglom_clusters.csv')
df_clusters$Cluster = as.factor(df_clusters$Cluster)

gau['cluster_agglom'] = df_clusters['Cluster']

plot(gau['cluster_agglom'])




