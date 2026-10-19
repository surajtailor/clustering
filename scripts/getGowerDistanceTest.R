getGowerDistanceTest <- function(seqDistances, sample.data, splitSeq){
  
  #Data Attributes
  #Distance matrix calculation
  gower.dissimilarity.mtrx <- daisy(sample.data, metric = c("gower"))
  
  #Extract nxm information from dataframe to nxm matrix.
  gowerDist <- as.matrix(gower.dissimilarity.mtrx)
  
  ###################################
  #DETERMINE SUMMATION TO P OF (DELTA_K)*(W_K). OUTPUT A MATRIX.
  
  #Work out which rows of matrix have NANs and which are blank.
  isNANDataframe <-  is.na.data.frame(sample.data)
  
  #Convert values in dataframe to 1 if false and 0 if true.
  binaryIsNANDataframe <- 1*!isNANDataframe
  
  #Optional step. Multiply each category by its weight. 
  
  #Matrix operation to determine summation values for each distance.
  sigmaMixedWeightMatrix <-binaryIsNANDataframe%*%t(binaryIsNANDataframe)
  
  ###################################
  #NORMALISE DISTANCE MATRIX ACCORDING TO GOWER's METRIC. DIVIDE EVERY VALUE BY RANGE OF DISTANCE OF MATRIX.
  
  normDistancesScalar<-1/diff(range(seqDistances))
  
  gowerSeqDistances <- normDistancesScalar*(seqDistances-min(seqDistances))
  
  ###################################
  #DETERMINE (DELTA_(P+1)*(W_(P+1))*D_{ij}. OUTPUT A MATRIX.
  
  #Work out which sequences are blank or NAN
  isNANSplitSeq <-is.nan(splitSeq)
  
  #Convert values in split
  binaryISNANSplitSeq <- 1*!isNANSplitSeq
  
  #Optional Step. Multiply by weight.
  
  #Matrix operation to determinee summation values for each sequence distance
  
  sigmaSeqWeightMatrix <- binaryISNANSplitSeq%*%t(binaryISNANSplitSeq)
  
  ###################################
  #DETERMINE SUMMATION TO P+1 of (DELTA_K)*(W_k). OUTPUT A MATRIX.
  
  sigmaTotalWeightMatrix <- sigmaSeqWeightMatrix + sigmaMixedWeightMatrix
  
  ##################################
  #FINAL DISTANCE MATRIX
  
  finalDistanceMatrix <- (sigmaMixedWeightMatrix/sigmaTotalWeightMatrix)*(gowerDist + (sigmaSeqWeightMatrix*gowerSeqDistances)/sigmaMixedWeightMatrix)
  
  return(finalDistanceMatrix)
}