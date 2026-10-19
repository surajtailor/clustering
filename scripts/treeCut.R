treeCut <- function(hc, bestK, uniqueSequences, FN_OUTPUT){

#cut the tree using bestK as the number of clusters
#assign a cluster number to each sequence
clusterNumbers<-cutree(hc,k=bestK,order_clusters_as_data = TRUE)
clusteredUniSeq <- cbind(uniqueSequences[,"id_uniqueSeq"],as.character(uniqueSequences[,"sequence"]),clusterNumbers)
colnames(clusteredUniSeq)<-c("id_uniqueSeq","sequence","cluster")
clusteredUniSeq<-clusteredUniSeq[order(as.numeric(clusteredUniSeq[,"cluster"])),]#order by cluster number

#write file with the sequences and cluster number
#write.table(clusteredUniSeq,file=sprintf('%s/scripts', this.dir),row.names=FALSE,col.names=FALSE,quote = FALSE,sep = ",")

return(clusteredUniSeq)

}