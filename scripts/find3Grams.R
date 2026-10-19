#Creates 3 grams from every sequence and stores as data frame. 
find3Grams <- function(splitSeq,filteredUniqueSequences){
  
  #create empty data frame to collect gramdata along with unique sequence id
  gramDataFrame <- data.frame(matrix(ncol =6, nrow=0))
  
  for(i in 1:length(splitSeq)){
    
    #separates into 3 grams and stores as type S4.
    gramData<-ngram(splitSeq[i], n=3, "-")
    
    #obtains table of all n grams and their frequency #tempgramtable is a dummyvariable
    tempGramTable<- get.phrasetable(gramData)
    
    #append 3grams table to relevent unique id.
    tempDataFrame<- data.frame(filteredUniqueSequences[i,],tempGramTable)
    
    #collect all gram data into dataframe
    gramDataFrame<- rbind(gramDataFrame,tempDataFrame)
    
  }
  
  #obtain frequencies of the respective 3grams
  gramDataFrame = data.frame(gramDataFrame,gramDataFrame$frequency*gramDataFrame$freq)
  
  #adjust names of columns
  y <-c("id_uniqueSeq","frequency","sequence","ngram","freq", "prop", "gramfrequency")
  colnames(gramDataFrame)<- y
  
  #removes row names - useful for testing
  rownames(gramDataFrame) <- c()
  
  return(gramDataFrame)
}