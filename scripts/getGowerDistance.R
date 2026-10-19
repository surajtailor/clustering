getGowerDistance <- function(seqDistances, splitSeq){
  
  #Data Attributes
  #Example data with different types of data found online. Pay attention to formating
  age <- c(21,21,19,30,21,21,19,30,10,20,30,40,50,60)
  gender <- c('M','M','N','M','F','F','F','F','M','F','M','F', 'M', 'F')
  gender <- as.factor(gender)
  civil_status <- c('MARRIED','SINGLE','SINGLE','SINGLE','MARRIED','SINGLE','WIDOW','DIVORCED','WIDOW','DIVORCED','WIDOW','DIVORCED','WIDOW','DIVORCED')
  civil_status <- as.factor(civil_status)
  salary <-c (3000.0,1200.0 ,32000.0,1800.0 ,2900.0 ,1100.0 ,10000.0,1500.0, 3000.0,1200.0 ,32000.0,1800.0 ,2900.0 ,1100.0 )
  has_children <-c (TRUE,FALSE,TRUE,TRUE,TRUE,FALSE,FALSE,TRUE,TRUE,FALSE,TRUE,TRUE,TRUE,FALSE)
  available_credit <- c (2200,100,22000,1100,2000,100,6000,2200,7000,6000,3400,6540,1234,5678)
  
  #Putting all data into a data frame
  sample.data <- data.frame(age, gender, civil_status, salary, has_children, available_credit)
  
  #Printing dimensions and and data frame
  print(dim(sample.data))
  sample.data  
  
  ###################################
  #DISTANCE OR DISSIMILARITY MATRIX CALCULATION
  
  #Gower Distance Matrix 
  gower.dissimilarity.mtrx <- daisy(sample.data, metric = c("gower"))
  gowerdist <- gower.dissimilarity.mtrx
  
  ###################################
  #FORMATTING DATAFRAME AND RELABELING PARAMETER
  
  #Extract nxm information from dataframe to nxm matrix.
  dissimilarity.mtrx.csv.content = as.matrix(gower.dissimilarity.mtrx)
  
  #Not sure what this does??
  write.table(dissimilarity.mtrx.csv.content, 'dissimilarirty.mtrx.csv', row.names = FALSE, col.names = FALSE, sep= ",")
  
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
  
  finalDistanceMatrix <- (sigmaMixedWeightMatrix/sigmaTotalWeightMatrix)*(dissimilarity.mtrx.csv.content + (sigmaSeqWeightMatrix*gowerSeqDistances)/sigmaMixedWeightMatrix)
  
  return(finalDistanceMatrix)

}