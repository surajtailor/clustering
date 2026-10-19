#PARAMS: uniqueSequences, a dataframe with the column id_uniqueSeq, frequency, sequence (string of numbers separated by "-", e.g. "4-33-12-1)
#RETURNS clusteredUniSeq, a dataframe with the same columns as uniqueSequences PLUS the column "cluster" to indicate the cluster number 
clusterUniqueSequences<-function(finalDistances, maxNumberClusters, PLOT_SILHOUETTE, SAVE_PLOT_SILHOUETTE, FN_SUFFIX, FN_OUTPUT){
  
  #Hierarchical Clustering Analysis 
  hc <- hclust(method="complete", as.dist(finalDistances))
  
  #Compute silhouette clusters
  means<-array()
  for(i in 2:maxNumberClusters){ 
    sil_cl <- silhouette(cutree(hc,k=i), as.dist(finalDistances))
    m<-mean(sil_cl[,"sil_width"])
    means[i]<-m
    #print(sprintf("k: %s silhouette mean: %s",i,m))
    i=i+1
    #rownames(sil_cl) <- rownames(distances)
    #plot(sil_cl)
  }
  
  #Plot silhouette plot
  if(PLOT_SILHOUETTE){
    plot(means,type = "o",main = sprintf("Average Silhouette Width for %s",FN_SUFFIX),ylab="Average Silhouette Width",xlab = "number of clusters")
  }
  
  #Save sillhhoutte plot
  if(SAVE_PLOT_SILHOUETTE){
    jpeg(sprintf("outputImages/ASW_%s.jpg",FN_SUFFIX), width = 500, height = 360)
    plot(means,type = "o",main = sprintf("Average Silhouette Width for %s",FN_SUFFIX),ylab="Average Silhouette Width",xlab = "number of clusters")
    dev.off()
  }  
  
  #Best number of clusters
  bestK<-which.max(means)
  print(sprintf("The optimal number of clusters is %s",bestK))
  
  #Put it on a list
  clusteringInfo <- list(bestK, hc)

  return (clusteringInfo)
}