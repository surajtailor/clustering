#Find unique three grams from dataframe.
findUnique3Grams <- function(gramDataFrame){
  uniqueThreeGrams <- unique(gramDataFrame$ngram)
  return(uniqueThreeGrams)
}