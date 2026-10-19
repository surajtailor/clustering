#Find norm(a) of of the countRGL or LGR combinations. Outputs a vector.
calcInsNormVector <- function(countRGL){
  
  #Summation of all elements within matrix countrightgivenleft to find normvector
  normVector <- rowSums(countRGL)
  
  #Check if normvalue = 0
  if(sum(normVector) == 0){
    print("Norm Value = 0. Check your data.")
  }
  
  return(normVector)
}