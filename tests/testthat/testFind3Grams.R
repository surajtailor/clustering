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
library(testthat)

#Source file to test
setwd("..")
setwd("..")
source(sprintf("%s/scripts/find3Grams.R", getwd()))

#TEST 1 using testdata.csv
#Inputs
id_uniqueSeq1 <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14)
frequency1 <- c(2,2,2,2,2,2,2,2,2,2,2,2,2,2)
sequence1 <- c('1','1-2','1-2-3', '1-2-3-4', '4-1-2-3', '3-4-1-2', '2-3-4-1', '4-3-2-1', '1-2-3-4-1-2-3-4', '4-3-2-1-4-3-2-1', '1-3-3', '2-4-4', '3-1-1', '4-2-2')
labels <- c('id_uniqueSeq','frequency', 'sequence')
filteredUniqueSequences <- data.frame(id_uniqueSeq1, frequency1, sequence1)
colnames(test1Input) <- labels

splitSeq <- c('1-5-5','1-2-5','1-2-3', '1-2-3-4', '4-1-2-3', '3-4-1-2', '2-3-4-1', '4-3-2-1', '1-2-3-4-1-2-3-4', '4-3-2-1-4-3-2-1', '1-3-3', '2-4-4', '3-1-1', '4-2-2')

#Output
id_uniqueSeq <- c(1,2,3,4,4,5,5,6,6,7,7,8,8,9,9,9,9,10,10,10,10,11,12,13,14)
frequency <- c(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)
sequence <- c('1','1-2','1-2-3','1-2-3-4','1-2-3-4','4-1-2-3','4-1-2-3','3-4-1-2','3-4-1-2','2-3-4-1','2-3-4-1','4-3-2-1','4-3-2-1','1-2-3-4-1-2-3-4','1-2-3-4-1-2-3-4','1-2-3-4-1-2-3-4','1-2-3-4-1-2-3-4','4-3-2-1-4-3-2-1','4-3-2-1-4-3-2-1','4-3-2-1-4-3-2-1','4-3-2-1-4-3-2-1','1-3-3','2-4-4','3-1-1','4-2-2')
ngram <- c('1 5 5 ', '1 2 5 ', '1 2 3 ', '2 3 4 ', '1 2 3 ', '4 1 2 ', '1 2 3 ', '4 1 2 ', '3 4 1 ', '2 3 4 ', '3 4 1 ', '4 3 2 ', '3 2 1 ', '2 3 4 ', '1 2 3 ', '4 1 2 ', '3 4 1 ', '4 3 2 ', '3 2 1 ', '2 1 4 ', '1 4 3 ', '1 3 3 ', '2 4 4 ', '3 1 1 ', '4 2 2 ')
freq <- c(1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,2,2,1,1,1,1,1,1)
prop <- c(1.00000000,1.00000000,1.00000000,0.5000000,0.5000000,0.5000000,0.5000000,0.5000000,0.5000000,0.5000000,0.5000000,0.5000000,0.5000000,1/3,1/3,1/6,1/6,1/3,1/3,1/6,1/6,1.0000000,1.0000000,1.0000000,1.0000000)
gramfrequency<-c(2,2,2,2,2,2,2,2,2,2,2,2,2,4,4,2,2,4,4,2,2,2,2,2,2)
test1ExpResult <- data.frame(id_uniqueSeq, frequency, sequence, ngram, freq, prop, gramfrequency)
rownames(test1ExpResult) <- c()

#Tests
test_that("should work", {expect_equal(find3Grams(splitSeq, filteredUniqueSequences), test1ExpResult)})