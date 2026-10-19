#Calculate normalized co-count matrix.
calcNormalizedCoCount <- function(coCount){
  
  #Summation of all elements within matrix cocount to find N (norm)
  normValue <- sum(coCount)
  
  #check if normvalue = 0
  if(normValue == 0){
    print("Norm Value = 0. Check your data.")
  }
  
  else{
    #Normalising all elements of the matrix
    normalizedCoCount <- coCount/normValue
    return(normalizedCoCount)
  }
}