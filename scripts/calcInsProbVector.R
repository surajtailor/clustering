#Find probability of occurances of event a.
calcInsProbVector <- function(normvector){
  
  #sum of all occurances is sum of countRGL. sum of rows is frequency of a. Freq/TotalOccuramces
  RGLProbVector <- normvector/sum(normvector)
  
  return(RGLProbVector)
}