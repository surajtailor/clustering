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
source(sprintf("%s/scripts/calcCoCountMatrix.R", getwd()))

#TEST 1 using testdata.csv
#Input
frequency <- c(2,2,10,8,6,6,6,6,2,2,2,2,2,2)
uniqueThreeGrams <- c('1 5 5 ', '1 2 5 ', '1 2 3 ', '2 3 4 ', '4 1 2 ', '3 4 1 ', '4 3 2 ', '3 2 1 ', '2 1 4 ', '1 4 3 ', '1 3 3 ', '2 4 4 ', '3 1 1 ', '4 2 2 ')
totalFreq3Grams1 <- data.frame(uniqueThreeGrams, frequency)

#Output
test1ExpResult<-matrix(c(17,24,52,16,0,24,62,32,56,4,52,32,44,20,0,16,56,20,17,0,0,4,0,0,1),nrow=5, byrow = TRUE)

#Tests
test_that("should work", {expect_equal(calcCoCountMatrix(totalFreq3Grams1, CARDINALITY_EVENTS = 5), test1ExpResult)})