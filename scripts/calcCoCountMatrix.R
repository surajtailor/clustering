#Calculate cocount of three grams and output a matrix of values dim = CARDxCARD
calcCoCountMatrix <- function(totalFreq3Grams,CARDINALITY_EVENTS){
  
  #cocount a matrix of the counts of all co occurance combinations. Set 12 for size of alphabet.
  coCount <- matrix(0,CARDINALITY_EVENTS,CARDINALITY_EVENTS)
  
  #CASE C(a,b) a = b
  for(i in 1:CARDINALITY_EVENTS){
    
    #filter through all possible threegrams to find all possible contexts of a
    for(j in 1:nrow(totalFreq3Grams)){
      
      #dissecting three grams into first letter, second letter and third letter
      k <- totalFreq3Grams$uniqueThreeGrams[j]
      kFirstLetter <- word(k, 1)
      kSecondLetter <- word(k, 2)
      kThirdLetter <- word(k, 3)
      
      #when the middle letter matches a it has found a context of a.
      if(kSecondLetter == sprintf("%s", i)){
        
        #Complete cases where C(a,b), where a=b i.e the diagonal filters through all possible 3 grams to find matches in context.
        for(m in 1:nrow(totalFreq3Grams)){
          
          n <- totalFreq3Grams$uniqueThreeGrams[m]
          nFirstLetter <- word(n, 1)
          nSecondLetter <- word(n, 2)
          nThirdLetter <- word(n, 3)
          
          #if a = b uses a n choose 2 formula 
          if(kSecondLetter == nSecondLetter){
            
            o <- totalFreq3Grams$frequency[m]
            coCount[i,i] = o*(o -1)/2 + coCount[i,i]
          }
        }
        break
      }
    }
  }
  
  #Case C(a,b) a != b #initially set our a
  for(i in 1:CARDINALITY_EVENTS){
    
    #filter through all possible three grams to find all possible contexts of a
    for(j in 1:nrow(totalFreq3Grams)){
      
      #dissecting three grams into first letter, second letter and third letter
      k <- totalFreq3Grams$uniqueThreeGrams[j]
      kFirstLetter <- word(k, 1)
      kSecondLetter <- word(k, 2)
      kThirdLetter <- word(k, 3)
      
      #when the middle letter matches a (or s) it has found a context of a.
      if(kSecondLetter == sprintf("%s", i)){
        
        for(l in 1 : CARDINALITY_EVENTS){
          
          #Complete cases where C(a,b), where a=b i.e the diagonal filters through all possible 3 grams to find matches in context.
          for(m in 1:nrow(totalFreq3Grams)){
            
            n <- totalFreq3Grams$uniqueThreeGrams[m]
            nFirstLetter <- word(n, 1)
            nSecondLetter <- word(n, 2)
            nThirdLetter <- word(n, 3)
            
            #if a != b uses a n_i*n_l  formula 
            if(kFirstLetter == nFirstLetter && kSecondLetter != nSecondLetter && kThirdLetter == nThirdLetter && nSecondLetter == sprintf("%s", l)){
              
              coCount[i,l] = totalFreq3Grams$frequency[j]*totalFreq3Grams$frequency[m] + coCount[i,l]
            }
          }
        }
      }
    }
  }
  
  return(coCount)
}