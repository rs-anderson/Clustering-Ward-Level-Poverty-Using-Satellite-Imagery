################ validation ###################
# this script aims to do a validation analysis of the cluster allocations
rm(list=ls())

# set working directory:
# set working directory
current_path <- rstudioapi::getActiveDocumentContext()$path
setwd(dirname(current_path))

################# K-means validation ################

# read in cluster allocations of the following cases:

## 6 pc's, 2 clusters
labels_6_2 <- read.csv("./cluster_labels/508wards_6pc_2cluster.csv")
labels_6_2 <- labels_6_2[,3]

## 6 pc's, 6 clusters
labels_6_6 <- read.csv("./cluster_labels/508wards_6pc_6cluster.csv")
labels_6_6 <- labels_6_6[,3]

# read in sampi values:
df_sampi <- read.csv("final_data.csv")
df_sampi <- df_sampi[,c(2:6)]

# investigate transformations of SAMPI-values
hist(df_sampi$sampi, breaks=20)
hist(log(df_sampi$sampi))
hist((df_sampi$sampi)^(1/2))
hist((df_sampi$sampi)^(1/3))
hist((df_sampi$sampi)^(1/4))
hist((df_sampi$sampi)^(1/5))
hist((df_sampi$sampi)^(1/11))

# compare original sampi values and fifth root
par(mfrow=c(1,2))
hist(df_sampi$sampi, breaks=15, col="lightblue", main="Untransformed",
     xlab = "SAMPI", cex.main=1.1, cex.axis= 1, cex.lab=1.1) 
hist(df_sampi$sampi^(1/5), breaks=15, col="lightblue", main="Fifth root",
     xlab = "SAMPI", cex.main=1.1, cex.axis= 1, cex.lab=1.1) 

# take fifth root of sampi values:
df_sampi$sampi_transform <- df_sampi$sampi^(1/5)

# boxplots using fifth roots:
## 6 principal components
### reorder boxplots by median:

bymedian1 <- with(df_sampi, reorder(labels_6_2, df_sampi$sampi_transform, median))
bymedian2 <- with(df_sampi, reorder(labels_6_6, df_sampi$sampi_transform, median))

### create boxplots for K=2 and K=6

par(mfrow=c(1,2))
boxplot(df_sampi$sampi_transform~bymedian1, col="lightgreen",
        xlab="Cluster allocation", ylab="SAMPI", cex.lab=1.2,
        cex.axis=1, main="K=2")
boxplot(df_sampi$sampi_transform~bymedian2, col="lightgreen",
        xlab="Cluster allocation", ylab="SAMPI", cex.lab=1.2,
        cex.axis=1, main="K=6")

################## HDBSCAN VALIDATION ######################
# focusing on the 18PCs case
# read in cluster allocations for HDBSCAN
labels_hdbscan_18 <- read.csv("./cluster_labels/HDBSCAN_clusters_18.csv")
labels_hdbscan_18 <- labels_hdbscan_18[,4]

# reorder the sampi values by median
bymedian <- with(df_sampi, reorder(labels_hdbscan_18,df_sampi$sampi_transform, median))

# plot the boxplot
boxplot(df_sampi$sampi_transform~bymedian , col="lightpink",
        xlab="Cluster allocation", ylab="SAMPI", cex.lab=1.2,
        cex.axis=1.2)








