#Determine Matrix E of expected values
calcCoCountExpMatrix <- function(probVector){
  
  #Matrix operation of probvector*probvector*2 (will need to correct diagonals)
  expectedMatrix <- 2*(probVector %*% t(probVector))
  
  #Correcting the diagonals of the matrix 
  correctDiagonal <- probVector %*% t(probVector)
  diag(expectedMatrix) <- diag(correctDiagonal)
  
  return(expectedMatrix)
}