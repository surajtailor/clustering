#LIBRARIES
library(cluster)
library(clustMixType)

################################
#DATA ATTRIBUTES 
#Example data with different types of data found online. Pay attention to formating
age <- c(21,21,19,30,21,21,19,30)
gender <- c('M','M','N','M','F','F','F','F')
gender <- as.factor(gender)
civil_status <- c('MARRIED','SINGLE','SINGLE','SINGLE','MARRIED','SINGLE','WIDOW','DIVORCED')
civil_status <- as.factor(civil_status)
salary <-c (3000.0,1200.0 ,32000.0,1800.0 ,2900.0 ,1100.0 ,10000.0,1500.0)
has_children <-c (TRUE,FALSE,TRUE,TRUE,TRUE,FALSE,FALSE,TRUE)
available_credit <- c (2200,100,22000,1100,2000,100,6000,2200)

#Putting all data into a data frame
sample.data <- data.frame(age, gender, civil_status, salary, has_children, available_credit)

#Printing dimensions and and data frame
print(dim(sample.data))
sample.data

###################################
#DISTANCE OR DISSIMILARITY MATRIX CALCULATION

#Gower Distance Matrix 
gower.dissimilarity.mtrx <- daisy(sample.data, metric = c("gower"))
gowerdist <- gower.dissimilarity.mtrx

#k-Prototype Distance Matrix - only want the output to be the dist function so iter.max = 100 and nstart = 1
#This does not output a distance matrix but performs the clustering outright.
kprotoinfo <- kproto(sample.data, 4, lambda = NULL, iter.max = 100, nstart = 1, na.rm = TRUE, keep.data = TRUE)
kprotodist <- kprotoinfo$dists

###################################
#FORMATTING DATAFRAME AND RELABELING PARAMETER

#Extract nxm information from dataframe to nxm matrix.
dissimilarity.mtrx.csv.content = as.matrix(gower.dissimilarity.mtrx)

#Not sure what this does??
write.table(dissimilarity.mtrx.csv.content, 'dissimilarirty.mtrx.csv', row.names = FALSE, col.names = FALSE, sep= ",")

#################################
#CLUSTERING METHODS 

#K Medoids 
#Mess around with cluster number using the silouhette plots seeing whether most are positive. 
#pamx <- pam(dist, 4)

#Sillouhette plot to determine how well the data points reflect their clutter
#sil = silhouette (pamx$clustering, dist)
#plot(sil)

#Divisive clustering approach
#Diana = divisive analysis clustering
#divisive.clust <- diana(gowerdist, diss=TRUE, keep.diss = TRUE)
#plot(divisive.clust, main = "Divisive")

#Agglomartive Clustering
#aggl.clust.c <- hclust(gower.dist, method = "complete")
#plot(aggl.clust.c,main = "Agglomerative, complete linkages")
