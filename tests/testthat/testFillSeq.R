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
source(sprintf("%s/scripts/fillSeq.R", getwd()))

#TEST 1 using testdata.csv
#Inputs
id_uniqueSeq1 <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14)
frequency1 <- c(2,2,2,2,2,2,2,2,2,2,2,2,2,2)
sequence1 <- c('1','1-2','1-2-3', '1-2-3-4', '4-1-2-3', '3-4-1-2', '2-3-4-1', '4-3-2-1', '1-2-3-4-1-2-3-4', '4-3-2-1-4-3-2-1', '1-3-3', '2-4-4', '3-1-1', '4-2-2')
labels <- c('id_uniqueSeq','frequency', 'sequence')
test1Input <- data.frame(id_uniqueSeq1, frequency1, sequence1)
colnames(test1Input) <- labels
CARDINALITY_EVENTS <- 5

#Expected results
test1ExpResult <- c('1-5-5','1-2-5','1-2-3', '1-2-3-4', '4-1-2-3', '3-4-1-2', '2-3-4-1', '4-3-2-1', '1-2-3-4-1-2-3-4', '4-3-2-1-4-3-2-1', '1-3-3', '2-4-4', '3-1-1', '4-2-2')

#Tests
test_that("should work", {expect_equal(fillSeq(test1Input, CARDINALITY_EVENTS), test1ExpResult)})