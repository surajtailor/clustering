#Create matrix for normCountRightGivenLeft(a/b) combinations
calcNormInsMatrix <- function(normVector,countRGL){
  
  #Dimensions of matrix of zeros
  xydim <- nrow(countRGL)
  
  #Norm_rgl_matrix full of zeros
  normRGLMatrix <- matrix(0, xydim, xydim)
  
  #Loop to create a matrix normCountRightGivenLeft(a/b)
  for(i in 1:xydim){
    
    #checks to make sure not dividingbyzero
    if (normVector[i] > 0){
      #Divides each row with the appropriate norm
      normRGLMatrix[i,] <- countRGL[i,]/normVector[i]
    }
    
  }
  return(normRGLMatrix)
}