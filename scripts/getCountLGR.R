#Get count of all LEFTGIVENRIGHT occurrences using totalfreq3gram data and alphabet. Outputs a matrix of dim = CARDxCARD
getCountLGR <- function(CARDINALITY_EVENTS, totalFreq3Grams){
  
  #a matrix of the counts of all RIGHTGIVENLEFT combinations
  countRGL <- matrix(0,CARDINALITY_EVENTS,CARDINALITY_EVENTS)
  
  #set the first letter, a, of C(a) where we are filtering through all possibilities of xay where a is fixed and y is eventually fixed.
  for(i in 1:CARDINALITY_EVENTS){
    
    #sets the second letter, y, of xay in C(a).
    for(l in 1:CARDINALITY_EVENTS){
      
      #filter through all possible threegrams to find all possible contexts of a and y
      rows<-nrow(totalFreq3Grams)
      for(j in 1:rows){
        
        #dissecting three grams into first letter, second letter and third letter
        k <- totalFreq3Grams$uniqueThreeGrams[j]
        kFirstLetter <- word(k, 1)
        kSecondLetter <- word(k, 2)
        kThirdLetter <- word(k, 3)
        
        #if the y's match and middle letter matches then sums these elements together and stores in a matrix where rows correspond to C(a) with a fixed y and variable x.
        if(kSecondLetter == sprintf("%s",i ) && kThirdLetter == sprintf("%s",l)){
          
          o <- totalFreq3Grams$frequency[j]
          countRGL[i,l] = o + countRGL[i,l]
          
        }
      }
    }
  }
  return(countRGL)
}