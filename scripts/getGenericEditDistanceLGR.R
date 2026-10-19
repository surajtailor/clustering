getGenericEditDistanceLGR <- function(splitSeq, insLGRMatrix, subsMatrix){

  #Pick out a unique sequence and convert them to vector numeric form.
  seqToVector <- function(splitSeq, i){
    
    #Take splitSeq and take out dashes
    firstSeqList  <- strsplit(splitSeq[i], '-')
    #Unlist the Seq
    firstSeq <- unlist(firstSeqList)
    #Put the list into a matrix
    seqVectorChar <- matrix(firstSeq)
    #Convert to numeric type
    seqVectorNum <- as.numeric(seqVectorChar)
    #Determine length of seq vector
    seqLength <- length(seqVectorNum)
    
    return(seqVectorNum)
  }
  
  #Determine number of sequences in list of sequences
  numSeq <- length(splitSeq)
  
  #Create blank dist matrix
  distances <- matrix(0, numSeq, numSeq)
  
  #Selects first sequence.
  for(i in 1:numSeq){
    
  firstSeqVectorNum <- seqToVector(splitSeq, i)
    
    #Selects the sequence to compare first sequence against.
    for(j in 1:numSeq){
    
    secondSeqVectorNum <- seqToVector(splitSeq, j)
      
      #Create empty (firstSeqLength +1) x (secondSeqLength + 1) editmatrix
      firstSeqLength <- length(firstSeqVectorNum)
      secondSeqLength <- length(secondSeqVectorNum)
      matrixRow <- firstSeqLength + 1
      matrixCol <- secondSeqLength + 1
      editMatrix <- matrix(0, matrixRow, matrixCol) 
      
      #Determine [,matrixRow] values of edit matrix
      for(l in (matrixRow-2):1){
      
        #Iteratively update rows going up
        editMatrix[l,1] <- insLGRMatrix[firstSeqVectorNum[l], firstSeqVectorNum[l+1]] + editMatrix[l+1,1]
      } 
      
      #Determine [matrixCol,] values of editmatrix 
      for(m in (matrixCol-2):1){
        
        #Iteratively update columns going left
        editMatrix[1,m] <- insLGRMatrix[secondSeqVectorNum[m], secondSeqVectorNum[m+1]] + editMatrix[1, m+1]
      }
      
      #Determine [matrixRow-1,matrixCol-1] special case of editmatrix 
      subCost<- subsMatrix[firstSeqVectorNum[matrixRow-1],secondSeqVectorNum[matrixCol-1]] + editMatrix[matrixRow,matrixCol]
      editMatrix[matrixRow-1,matrixCol-1] <- max(0, subCost)
      
      #Determine second row of edit matrix 
      for (p in (matrixCol-2):1) {
        
        subCost <- subsMatrix[firstSeqVectorNum[matrixRow-1], secondSeqVectorNum[p]] + editMatrix[matrixRow,p+1]
        insertionLGRCost <-  insLGRMatrix[secondSeqVectorNum[p], secondSeqVectorNum[p+1]] + editMatrix[matrixRow-1,p+1]
        deletionLGRCost <- editMatrix[matrixRow,p]
      
        editMatrix[matrixRow-1,p] <- max(subCost, deletionLGRCost, insertionLGRCost)
      }
      
      #Determine second column of edit matrix
      for (q in (matrixRow-2):1){
        
        subCost <- subsMatrix[firstSeqVectorNum[q], secondSeqVectorNum[matrixCol-1]] + editMatrix[q-1,matrixCol]
        insertionLGRCost <- editMatrix[q,matrixCol]
        deletionLGRCost <- insLGRMatrix[firstSeqVectorNum[q], firstSeqVectorNum[q+1]] + editMatrix[q-1,matrixCol-1]
        
        #assign the maxcost to the element within editmatrix
        editMatrix[q,matrixCol-1] <- max(subCost, deletionLGRCost, insertionLGRCost)
      }
      
      #Rest of algorithm row by row starting [matrixRow-2,matrixCol-2]
      for(n in (matrixRow-2):1){
        
        for(o in (matrixCol-2):1){ 
          
          subCost <- subsMatrix[firstSeqVectorNum[n],secondSeqVectorNum[o]] + editMatrix[n+1,o+1] 
          insertionLGRCost <-  insLGRMatrix[secondSeqVectorNum[o],secondSeqVectorNum[o+1]] + editMatrix[n,o+1] 
          deletionLGRCost <- insLGRMatrix[firstSeqVectorNum[n],firstSeqVectorNum[n+1]] + editMatrix[n+1, o]
          
          #assign the maxcost to the element within editMatrix
          editMatrix[n,o] <- max(subCost, deletionLGRCost,insertionLGRCost)
        
        }
      }
     
        #add the similarity values to the matrix.
        distances[i,j] <- editMatrix[1, 1]
        
        #use the similarity values to make into distances according to paper.
        distances[i,j] <- (firstSeqLength + secondSeqLength)/distances[i,j]
    }
  }
  return(distances)
}