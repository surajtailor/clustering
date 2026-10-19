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
