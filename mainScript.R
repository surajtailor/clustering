#Open respective packages
library(cluster)
library(clustMixType)
library(factoextra)
library(NbClust)
library(quantmod)
library(dendextend)
library(colorspace)
library(devtools)
library(ngram)
library(stringr)
library(dplyr)
library(rstudioapi)
library(stringdist)
library(miceadds)

#Set working directory as the current folder
this.dir <- dirname(getActiveDocumentContext()$path)
setwd(this.dir)

#Initialize global variables
FN_INPUT<-"/data/testdata.csv"
FN_OUTPUT<-"/data/outputClustering.csv"
FN_SUFFIX<-"CHCData"
MAX_NUMBER_CLUSTERS<<-50 #compute the average silhouette for up to 50 clusterings
PLOT_SILHOUETTE<<-TRUE
PLOT_DENDROGRAM<<-TRUE
SAVE_PLOT_SILHOUETTE<<-TRUE
REMOVE_SEQ_FOR_CLUSTERING<<-TRUE #take only the most frequent sequences as input for the clustering?
N<<-30 #number of sequences as input to clustering. only used when REMOVE_SEQ_FOR_CLUSTERING is true
CARDINALITY_EVENTS <- 12 #number of unique elements in event space + 1 for blank events.
SHIFT_SCORES <- TRUE

#######################################################

#Source functions from functions folder.
source.all(sprintf('%s/scripts', this.dir))
print('Sourced all files within functions folder.')

#######################################################

#Data cleaning
uniqueSequences<-read.csv(sprintf("%s%s",getwd(),FN_INPUT))
filteredUniqueSequences<-reduceDataSize(uniqueSequences, REMOVE_SEQ_FOR_CLUSTERING, N) #tested
splitSeq <- fillSeq(filteredUniqueSequences, CARDINALITY_EVENTS) #tested
gramDataFrame <- find3Grams(splitSeq, filteredUniqueSequences) #tested: outputting fail due to incorrect rownames, but is outputting the correct things.
uniqueThreeGrams<-findUnique3Grams(gramDataFrame) #tested
totalFreq3Grams <- calcTotalFreq3Grams(gramDataFrame,uniqueThreeGrams) #tested

#Substitution matrix
coCount<-calcCoCountMatrix(totalFreq3Grams, CARDINALITY_EVENTS) #tested
normalizedCoCount<-calcNormalizedCoCount(coCount) #tested
coCountProbVector<-calcCoCountProbVector(normalizedCoCount) #tested
coCountExpMatrix<-calcCoCountExpMatrix(coCountProbVector) #tested
subsMatrix<-calcSubsMatrix(normalizedCoCount, coCountExpMatrix) #tested

#CountRGL and LGR
countRGL <- getCountRGL(CARDINALITY_EVENTS, totalFreq3Grams)#tested
countLGR <- getCountLGR(CARDINALITY_EVENTS, totalFreq3Grams)#tested

#InsRGLMatrix
RGLNormVector <- calcInsNormVector(countRGL) #tested
RGLProbVector <- calcInsProbVector(RGLNormVector) #not tested: simple function
normRGLMatrix <- calcNormInsMatrix(RGLNormVector, countRGL)#tested
insRGLMatrix <- calcInsMatrix2(normRGLMatrix, RGLProbVector, countRGL)#tested

#InsLGRMatrix
LGRNormVector <- calcInsNormVector(countRGL)#repeat
LGRProbVector <- calcInsProbVector(LGRNormVector)#repeat
normLGRMatrix <- calcNormInsMatrix(LGRNormVector, countLGR)#repeat
insLGRMatrix <- calcInsMatrix2(normLGRMatrix, LGRProbVector, countLGR)#repeat

#Shift scores to ensure distances are >0
if(SHIFT_SCORES == TRUE ){
shiftScoresOutputs <- shiftScores(insRGLMatrix,insLGRMatrix, subsMatrix)# not tested: simple function
subsMatrix <- shiftScoresOutputs[[1]]
insRGLMatrix <- shiftScoresOutputs[[2]]
insLGRMatrix <- shiftScoresOutputs[[3]]
}

#SeqDistance matrix function
seqDistancesRGL <- getGenericEditDistanceRGL(splitSeq, insRGLMatrix, subsMatrix) #tested
seqDistancesLGR <- getGenericEditDistanceLGR(splitSeq, insLGRMatrix, subsMatrix) #tested
print('Created seqDistances matrix. See seqDistances.')

#Alternate sequence distance function
seqDistanceRGLAlternate <- getGenericEditDistanceRGLAlternate(splitSeq, insRGLMatrix, subsMatrix) 

#Final distance function
finalDistanceMatrixRGL <- getGowerDistance(seqDistancesRGL, splitSeq) #tested
finalDistanceMatrixLGR <- getGowerDistance(seqDistancesLGR, splitSeq) #tested
#print('Created finalDistanceMatrix.')

#######################################################
#Obtain max number of clusters.
maxNumberClusters <- getMaxNumClusters(length(splitSeq)) #not tested

#Clustering processes.
clusteringInfo <- clusterUniqueSequences(finalDistanceMatrixRGL, maxNumberClusters, PLOT_SILHOUETTE, SAVE_PLOT_SILHOUETTE, FN_SUFFIX, FN_OUTPUT) #not tested
bestK <- clusteringInfo[[1]]
hc <- clusteringInfo[[2]]

#Cut tree using best number of clusters
clusteredUniqueSeq <- treeCut(hc, bestK, uniqueSequences, FN_OUTPUT) #not tested
print(clusteredUniqueSeq)

#Plot dendogram
plotDend(PLOT_DENDOGRAM,hc,bestK) #not tested
