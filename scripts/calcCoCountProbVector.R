#Determine probability vector of occurances of a particular event.
calcCoCountProbVector <- function(normalizedCoCount){
  
  numEvents <- nrow(normalizedCoCount)
  probVector <-  matrix(0,numEvents,1)
  
  for(i in 1:numEvents){
    probVector[i] <- sum(normalizedCoCount[i,])
  }
  
  return(probVector)
}