getGenericEditDistanceRGLAlternate <- function(splitSeq, insRGLMatrix, subsMatrix){

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
      
      #Determine [,1] values of edit matrix correct
      for(l in 3:matrixRow){
      
        #Iteratively update rows going down
        editMatrix[l,1] <- editMatrix[l-1,1]
      } 
      
      #Determine [1,] values of editmatrix 
      for(m in 3:matrixCol){
        
        #Iteratively update columns going across
        editMatrix[1,m] <- editMatrix[1, m-1]
      }
      
      #Determine [2,2] special case of editmatrix 
      subCost<- subsMatrix[firstSeqVectorNum[1],secondSeqVectorNum[1]] + editMatrix[1,1]
      editMatrix[2,2] <- max(0, subCost)
      
      #Determine second row of edit matrix 
      for (p in 3:matrixCol) {
        
        subCost <- subsMatrix[firstSeqVectorNum[1], secondSeqVectorNum[p-1]] + editMatrix[1,p-1]
        insertionRGLCost <-  insRGLMatrix[firstSeqVectorNum[1], secondSeqVectorNum[p-1]] + editMatrix[2,p-1]
        deletionRGLCost <- editMatrix[1,p]
      
        editMatrix[2,p] <- max(subCost, deletionRGLCost, insertionRGLCost)
      }
      
      #Determine second column of edit matrix
      for (q in 3:matrixRow)
      
      #Rest of algorithm row by row starting [3,3]
      for(n in 3:matrixRow){
        
        for(o in 3:matrixCol){ 
          
          subCost <- subsMatrix[firstSeqVectorNum[n-1],secondSeqVectorNum[o-1]] + editMatrix[n-1,o-1] 
          insertionRGLCost <-  insRGLMatrix[firstSeqVectorNum[n-1],secondSeqVectorNum[o-1]] + editMatrix[n,o-1] 
          deletionRGLCost <- insRGLMatrix[firstSeqVectorNum[n-1],secondSeqVectorNum[o-1]] + editMatrix[n-1, o]
          
          #assign the maxcost to the element within editMatrix
          editMatrix[n,o] <- max(subCost, deletionRGLCost,insertionRGLCost)
        
        }
      }
     
        #add the similarity values to the matrix.
        distances[i,j] <- editMatrix[matrixRow, matrixCol]
        
        #use the similarity values to make into distances according to paper.
        distances[i,j] <- (firstSeqLength + secondSeqLength)/distances[i,j]
    }
  }
  return(distances)
}
  