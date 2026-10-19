#Adds blank events to sequences of length less than three.
fillSeq <- function(filteredUniqueSequences, CARDINALITY_EVENTS){
  
  splitSeq<- as.character(filteredUniqueSequences[,"sequence"])
  
  for(i in 1:length(splitSeq)){
    
    # Attaches one blank event to the end.
    if(nchar(splitSeq[i]) == 3){
      splitSeq[i] <- paste0(splitSeq[i], c(sprintf('-%s',CARDINALITY_EVENTS)))
    }
    
    # Attaches two blank events to the end.
    else if(nchar(splitSeq[i]) == 1){
      splitSeq[i] <- paste0(splitSeq[i], c(sprintf('-%s-%s', CARDINALITY_EVENTS, CARDINALITY_EVENTS)))
    }
  }
  return(splitSeq)
}