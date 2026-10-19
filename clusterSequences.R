# (1) *****INITIALIZE****
#set working directory as the current folder
this.dir <- dirname(parent.frame(2)$ofile) 
setwd(this.dir)

#load libraries
#if the libraries are not installed. 
# use install.packages(c("cluster","factoextra","NbClust","quantmod","dendextend","colorspace"))
# or install.packages("cluster") for installing one at the time
library(cluster)
library(factoextra)
library(NbClust)
library(quantmod)
library(dendextend)
library(colorspace)

#initialize global variables
FN_INPUT<-"../data/uniqueSequences.csv"
FN_OUTPUT<-"../data/outputClustering.csv"
FN_SUFFIX<-"CHCData"
MAX_NUMBER_CLUSTERS<<-50 #compute the average silhouette for up to 50 clusterings
PLOT_SILHOUETTE<<-TRUE
PLOT_DENDROGRAM<<-TRUE
SAVE_PLOT_SILHOUETTE<<-TRUE
REMOVE_SEQ_FOR_CLUSTERING<<-TRUE #take only the most frequent sequences as input for the clustering?
N<<-30 #number of sequences as input to clustering. only used when REMOVE_SEQ_FOR_CLUSTERING is true 


# (2) *****DEFINE FUNCTIONS****

#PARAMS: 
# numSeq, the total number of sequences to be clustered
getMaxNumClusters<-function(numSeq){
  #Take the smallest number between numSeq and MAX_NUMBER_CLUSTERS 
  # this is so MAX_NUMBER_CLUSTERS is not higher than the number of sequences and causes an error.
  #also to avoid computing the silhouette for too many clusters
  if(MAX_NUMBER_CLUSTERS>(numSeq-1)){
    maxNumberClusters<-(numSeq-1)
  }else{
    maxNumberClusters<-MAX_NUMBER_CLUSTERS
  }
  return (maxNumberClusters)
}

#PARAMS: 
# hc, the result of hclust
# distances, the distance matrix
# numSeq, the total number of sequences to be clustered
#RETURNS: the average silhouette value for each possible number of clusters
computeAverageSilhouette<-function(hc,distances,numSeq){
  means<-array()
  maxNumberClusters<-getMaxNumClusters(numSeq)
  for(i in 2:maxNumberClusters){ 
    sil_cl <- silhouette(cutree(hc,k=i), as.dist(distances))
    m<-mean(sil_cl[,"sil_width"])
    means[i]<-m
    #print(sprintf("k: %s silhouette mean: %s",i,m))
    i=i+1
    #rownames(sil_cl) <- rownames(distances)
    #plot(sil_cl)
  }
  
  if(PLOT_SILHOUETTE){
    plot(means,type = "o",main = sprintf("Average Silhouette Width for %s",FN_SUFFIX),ylab="Average Silhouette Width",xlab = "number of clusters")
  }
  if(SAVE_PLOT_SILHOUETTE){
    jpeg(sprintf("outputImages/ASW_%s.jpg",FN_SUFFIX), width = 500, height = 360)
    plot(means,type = "o",main = sprintf("Average Silhouette Width for %s",FN_SUFFIX),ylab="Average Silhouette Width",xlab = "number of clusters")
    dev.off()
  }
  return (means)
}

#PARAMS: sequences, a list of sequences where each sequence is a string of numbers separated by "-". 
#           For example c("1-2-12-3","33-7-9-2-12"...). Each event separated by "-" must be integer
#RETURNS: a list of sequences where each number is converted into a unique character
# this method converts the events (numbers) in each sequence into a Utf8 string, where each event has a unique character
# the method to convert to Utf8 is necessary as adist computes distance between single characters, so this would be a problem when computing the distance between "10" and "3"
# we want 10 to be one character (event) and not two (1,0)
sequencesToUtf8<-function(sequences){
  splitSeq<-strsplit(sequences,"-")
  
  utfSeq<-matrix()
  i<-1
  for(s in splitSeq){
    utfSeq[i]<-intToUtf8(s)
    i=i+1
  }
  return (utfSeq);
}

#PARAMS: uniqueSequences, a dataframe with the column id_uniqueSeq, frequency, sequence (string of numbers separated by "-", e.g. "4-33-12-1)
#RETURNS clusteredUniSeq, a dataframe with the same columns as uniqueSequences PLUS the column "cluster" to indicate the cluster number 
clusterUniqueSequences<-function(uniqueSequences){

  #select the N most frequent unique sequences
  if(REMOVE_SEQ_FOR_CLUSTERING){
    uniqueSequences<-uniqueSequences[order(as.numeric(uniqueSequences[,"frequency"]),decreasing = TRUE),]
    if(nrow(uniqueSequences)>=N){
      uniqueSequences<-uniqueSequences[1:N,] 
    }
  }

  #convert sequences into string of unique characters
  sequences<-as.character(uniqueSequences[,"sequence"])
  utfSeq<-sequencesToUtf8(sequences)
  
  #compute distance matrix and perform clustering
  distances<-adist(utfSeq,costs = list(ins=1, del=1, sub=1))
  hc <- hclust(method="complete",as.dist(distances))
  
  means<-computeAverageSilhouette(hc,distances,nrow(uniqueSequences))
  
  #best number of clusters
  bestK<-which.max(means)
  print(sprintf("The optimal number of clusters is %s",bestK))

  if(PLOT_DENDROGRAM){
    dend <- as.dendrogram(hc)
    dend <- color_branches(dend, k = bestK)
    plot(dend)
  }

  #cut the tree using bestK as the number of clusters
  #assign a cluster number to each sequence
  clusterNumbers<-cutree(hc,k=bestK,order_clusters_as_data = TRUE)
  clusteredUniSeq <- cbind(uniqueSequences[,"id_uniqueSeq"],as.character(uniqueSequences[,"sequence"]),clusterNumbers)
  colnames(clusteredUniSeq)<-c("id_uniqueSeq","sequence","cluster")
  clusteredUniSeq<-clusteredUniSeq[order(as.numeric(clusteredUniSeq[,"cluster"])),]#order by cluster number
  
  #write file with the sequences and cluster number
  write.table(clusteredUniSeq,file=FN_OUTPUT,row.names=FALSE,col.names=FALSE,quote = FALSE,sep = ",")
  
  return (clusteredUniSeq)
}


# (3) *****MAIN CODE, CALL FUNCTIONS****
uniqueSequences<-read.csv(FN_INPUT)
clusteredUniSeq<-clusterUniqueSequences(uniqueSequences)
print(clusteredUniSeq)