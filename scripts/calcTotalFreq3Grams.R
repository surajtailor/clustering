#Calculates the count of each unique three gram within the data. 
calcTotalFreq3Grams <-function(gramDataFrame,uniqueThreeGrams){
  
  #Creating blank data frame for gram data
  gramData <- data.frame(matrix(0,ncol = 1, nrow=length(uniqueThreeGrams)))
  
  #Label the column for gramdata
  y <- c("frequency")
  colnames(gramData) <- y
  
  #looping through unique three grams in gramdataframe
  for(j in 1:length(uniqueThreeGrams)){
    
    #looping within everyrow within larger gramdataframe which has multiple instances of grams
    for (i in 1:nrow(gramDataFrame)){
      
      #filtering out instances where ngram matches the unique 3 gram = s
      if(gramDataFrame$ngram[i] == uniqueThreeGrams[j]){
        
        #cumulative total in within gram data
        gramData[j,1] <- gramDataFrame$gramfrequency[i] + gramData[j,1]
      }
    }
  }
  
  #consecates uniquethreegrams and their respective frequencies in the data.
  gramData <- data.frame(uniqueThreeGrams,gramData)
  
  #remove rownames
  #row.names(gramData)<-c()
  
  return(gramData)
}  