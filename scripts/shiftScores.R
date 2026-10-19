#shift all scores according to the absolute value of the lowest value of matrix.
shiftScores <- function(insRGLMatrix,insLGRMatrix, subsMatrix){
    
    #Shift subscores
    subsMatrix = abs(min(subsMatrix)) + subsMatrix
    
    #Shift insRGLMatrix scores
    insRGLMatrix = abs(min(insRGLMatrix)) + insRGLMatrix
    
    #Shift insLGRMatrix scores
    insLGRMatrix = abs(min(insLGRMatrix)) + insLGRMatrix
    
    #Concecate into list
    p <- list(subsMatrix, insRGLMatrix, insLGRMatrix)
    
    return(p)
  
}