library(sf)
library(googleway)
library(googlePolylines)
library(ggplot2)
library(gridExtra)

MUNICIPALITIES = c(
  'Emfuleni',
  'Merafong City',
  'Midvaal',
  'Lesedi',
  'Mogale City',
  'Ekurhuleni',
  'New',
  'City of Tshwane',
  'City of Johannesburg'
)


# reading in the geojson file for simple feature collection and additional fields
gau = sf::st_read("./Gau_shp.json")
str(gau)


# reading in clusters assigned to each ward
df_clusters = read.csv('cluster9_pc35.csv')
df_clusters$Cluster = as.factor(df_clusters$Cluster)
str(df_clusters)



for (munic in MUNICIPALITIES){
  gau[which(gau$MunicName == munic), 'cluster'] = df_clusters[which(df_clusters$Municipality == munic), 'Cluster']
}

str(gau)



plot(gau[which(gau$MunicName == 'City of Johannesburg')[135],'WardNo'])


mapKey <- "AIzaSyDLoj9wkzUiTr2TYsyCYphA6Nu1pDJIFnU"

google_map(key = mapKey) %>%
  add_polygons(data = gau[which(gau$MunicName == 'City of Johannesburg'),], polyline = "geometry", fill_colour = 'MunicName', fill_opacity = 0.9, mouse_over = 'WardNo')


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


########################################################
########################################################

library(readxl)
library(tidyr)


df_SAMPI = read_excel('SAMPI by Province, District, Municipality & Ward.xls', skip=1)



df_SAMPI = df_SAMPI %>% fill(names(df_SAMPI))

write.csv(df_SAMPI, 'SAMPI.csv')

sum(df_SAMPI[, 'DISTRICT'] == "City of Johannesburg", na.rm=TRUE)

inds_gau = which(df_SAMPI[,2] == 'Gauteng')


unique(df_SAMPI[inds_gau, 'MUNICIPALITY'])

inds_city_of_jhb = which(df_SAMPI[, 'MUNICIPALITY'] == "City of Johannesburg")
inds_city_of_jhb = inds_city_of_jhb[2:length(inds_city_of_jhb)]

city_of_jhb_SAMPI = df_SAMPI[inds_city_of_jhb, 12]  # 93 seems to be missing?
city_of_jhb_SAMPI = rbind(city_of_jhb_SAMPI[1:92,], c(0.06) , city_of_jhb_SAMPI[93:nrow(city_of_jhb_SAMPI),])
names(city_of_jhb_SAMPI) = "SAMPI"


# gau['SAMPI'] = city_of_jhb_SAMPI
# 
# plot(gau['SAMPI'])



###################################################

############### SUPERVISED LEARNING ###############

###################################################



# reading in clusters assigned to each ward
df_feats = read.csv('features.csv')
str(df_feats)
df_feats = df_feats[,-1]
str(df_feats)

dat = cbind(city_of_jhb_SAMPI, df_feats)
dim(dat)
names(dat)[1]

set.seed(2)

sample_split <- sample(1:nrow(dat), nrow(dat)*0.7) #70/30 split
train <- dat[sample_split,]
test <- dat[-sample_split,]

library(gbm)
gbm_lib <- gbm(SAMPI ~ ., data = train, 
               distribution = 'gaussian',
               n.trees = 1000,
               interaction.depth = 2,
               shrinkage = 0.01,
               bag.fraction = 1,
               cv.folds = 10)


BEST = which.min(gbm_lib$cv.error)
gbm_lib$cv.error[BEST]

x = 1:1000
plot(gbm_lib$cv.error ~ x, type="l")
abline(v = BEST)


y = test[,'SAMPI']
y = train[,'SAMPI']
yhat_gbm <- predict.gbm(gbm_lib, test, n.trees = BEST)
yhat_gbm <- predict.gbm(gbm_lib, train, n.trees = BEST)
(mse_gbm <- mean((y - yhat_gbm)^2))
(1 - sum((y - yhat_gbm)^2)/sum((y - mean(y))^2))


plot(y ~ yhat_gbm)


