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
source(sprintf("%s/scripts/reduceDataSize.R", getwd()))

#TEST 1 using testdata.csv
#Expected results
id_uniqueSeq1 <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14)
frequency1 <- c(2,2,2,2,2,2,2,2,2,2,2,2,2,2)
sequence1 <- c('1','1-2','1-2-3', '1-2-3-4', '4-1-2-3', '3-4-1-2', '2-3-4-1', '4-3-2-1', '1-2-3-4-1-2-3-4', '4-3-2-1-4-3-2-1', '1-3-3', '2-4-4', '3-1-1', '4-2-2')
labels <- c('id_uniqueSeq','frequency', 'sequence')
test1ExpResult <- data.frame(id_uniqueSeq1, frequency1, sequence1)
colnames(test1ExpResult) <- labels

#Inputs
FN_INPUT1<-sprintf('%s/data/testdata.csv', getwd())
uniqueSequences1<-read.csv(FN_INPUT1)

#Tests
test_that("should work, N=30 and REMOVE... = TRUE ", {expect_equal(reduceDataSize(uniqueSequences1, REMOVE_SEQ_FOR_CLUSTERING = TRUE, N = 30), test1ExpResult)})
test_that("should work, N=30 and REMOVE... = FALSE", {expect_equal(reduceDataSize(uniqueSequences1, REMOVE_SEQ_FOR_CLUSTERING= FALSE, N = 30), test1ExpResult)})
test_that("should fail, N=2 and REMOVE... = TRUE", {expect_equal(reduceDataSize(uniqueSequences1, REMOVE_SEQ_FOR_CLUSTERING= TRUE, N = 2), test1ExpResult)})
test_that("should work, N=2 and REMOVE... = FALSE", {expect_equal(reduceDataSize(uniqueSequences1, REMOVE_SEQ_FOR_CLUSTERING= FALSE, N = 2), test1ExpResult)})

#TEST 2 using uniqueSequences.csv
#Expected results
id_uniqueSeq2 <- c(4,3,15,2,6)
frequency2 <- c(5371, 5289, 4804, 3555, 519)
sequence2 <- c('1-2-5-6', '1-2-3-4-5-6','1-6', '1-2-3-4-7-8-5-6-9-10', '10-1-2-3-4-7-8-5-6-9')
test2ExpResult <- data.frame(id_uniqueSeq2, frequency2, sequence2)
collabels <- c('id_uniqueSeq','frequency', 'sequence')
colnames(test2ExpResult) <- collabels

#Inputs
FN_INPUT2 <-sprintf('%s/data/uniqueSequences.csv', getwd())
uniqueSequences2 <- read.csv(FN_INPUT2)

test_that("should work, N=5 and REMOVE... = TRUE ", {expect_equal(reduceDataSize(uniqueSequences2, REMOVE_SEQ_FOR_CLUSTERING = TRUE, N = 5), test2ExpResult)})
test_that("should fail, N=5 and REMOVE... = FALSE", {expect_equal(reduceDataSize(uniqueSequences2, REMOVE_SEQ_FOR_CLUSTERING= FALSE, N = 5), test2ExpResult)})