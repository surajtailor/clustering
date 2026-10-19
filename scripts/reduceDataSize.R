#Reduce data size by takng the top N frequency sequences.
reduceDataSize<-function(uniqueSequences, REMOVE_SEQ_FOR_CLUSTERING, N){
  
  #Checks if true.
  if(REMOVE_SEQ_FOR_CLUSTERING){
    uniqueSequences<-uniqueSequences[order(as.numeric(uniqueSequences[,"frequency"]),decreasing = TRUE),]
    
    #Takes the N largest row in database.
    if(nrow(uniqueSequences)>=N){
      uniqueSequences<-uniqueSequences[1:N,] 
    }
  }
  
  #turn on if you do not want row names
  row.names(uniqueSequences)<-c()
  
  return(uniqueSequences)
}