#Calc Insertion scores as defined by log-odds ratio.
calcInsMatrix2 <- function(normRGLMatrix, RGLProbVector, countRGL){
  
  #dimensions of matrix of zeros
  xydim <- nrow(normRGLMatrix)
  
  #matrix of zeros
  insRGLMatrix <- matrix(0, xydim, xydim) 
  
  #so we are not dividing by zero
  #if(RGLProbVector[i] > 0 && RGLProbVector[j] > 0 && normRGLMatrix[i,j]>0){
  
  #determine which values of count matrix is greater than 0
  nonZeroInd <- which(countRGL > 0, arr.ind = T)
  
  #insert calculated values 
  insRGLMatrix[nonZeroInd] <- log(normRGLMatrix[nonZeroInd]/(RGLProbVector[nonZeroInd[,1]]*RGLProbVector[nonZeroInd[,2]]),2)
  
  #determine which values if count matrix is less than or equal to 0
  zeroInd <- which(countRGL <= 0, arr.ind = T)
  
  #pa*px
  probMultArray <- RGLProbVector[zeroInd[,1]]*RGLProbVector[zeroInd[,2]]
  
  #log base 2 of 1 over expected matrix for values = 0
  insRGLMatrix[zeroInd] <- -log(1/(probMultArray),2)

  #remove Nans and inf values
  insRGLMatrix[is.nan(insRGLMatrix)] = 0
  insRGLMatrix[is.infinite(insRGLMatrix)] = 0
  
  return(insRGLMatrix)
  
  }

