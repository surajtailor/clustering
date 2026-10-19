#Calc Insertion scores as defined by log-odds ratio.
calcInsMatrix <- function(normRGLMatrix, RGLProbVector, countRGL){
  
  #dimensions of matrix of zeros
  xydim <- nrow(normRGLMatrix)
  
  #matrix of zeros
  insRGLMatrix <- matrix(0, xydim, xydim) 
  
  #loop to create log-odds ratio matrix looping through all elements of a in insRightGivenLeft(a/b).
  for(i in 1:xydim){
    
    #loop through all elements of b once a is set in insRightGivenLeft(a/b).
    for(j in 1:xydim){
      
      #so we are not dividing by zero
      #if(RGLProbVector[i] > 0 && RGLProbVector[j] > 0 && normRGLMatrix[i,j]>0){
        
        #insert calculated values 
        insRGLMatrix[i,j] <- log(normRGLMatrix[i,j]/(RGLProbVector[i]*RGLProbVector[j]),2)
        
        #determine which values if count matrix is less than or equal to 0
        zeroIndicies <- which(countRGL <= 0, arr.ind = T)
        
        #pa*px
        probMultArray <- RGLProbVector[zeroIndicies[,1]]*RGLProbVector[zeroIndicies[,2]]
        
        #log base 2 of 1 over expected matrix for values = 0
        insRGLMatrix[zeroIndicies] <- -log(1/(probMultArray),2)
        
      #}
    }
    
  }
  return(insRGLMatrix)
}
