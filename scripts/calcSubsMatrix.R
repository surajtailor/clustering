#Calculate substution matrix
calcSubsMatrix <- function(normalizedCoCount,expectedMatrix){
  
  #find indicies of elements equal to zero in normalizedCoCount
  zeroIndicies <- which(normalizedCoCount == 0, arr.ind = T)
  
  #log base 2 of nomalized cocount over expected matrix.
  subsMatrix <- log(normalizedCoCount/expectedMatrix,2)
  
  #log base 2 of 1 over expected matrix for values = 0
  subsMatrix[zeroIndicies] <- -log(1/(expectedMatrix[zeroIndicies]),2)
  
  #remove Nans and inf values
  subsMatrix[is.nan(subsMatrix)] = 0
  subsMatrix[is.infinite(subsMatrix)] = 0
  
  return(subsMatrix)
}

