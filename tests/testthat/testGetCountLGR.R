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
source(sprintf("%s/scripts/getCountLGR.R", getwd()))

#TEST 1 from testdata.csv
#Input
frequency <- c(2,2,10,8,6,6,6,6,2,2,2,2,2,2)
uniqueThreeGrams <- c('1 5 5 ', '1 2 5 ', '1 2 3 ', '2 3 4 ', '4 1 2 ', '3 4 1 ', '4 3 2 ', '3 2 1 ', '2 1 4 ', '1 4 3 ', '1 3 3 ', '2 4 4 ', '3 1 1 ', '4 2 2 ')
totalFreq3Grams1 <- data.frame(uniqueThreeGrams, frequency)

#Expected
test1ExpResult <- matrix(c(2,6,0,2,0,6,2,10,0,2,0,6,2,8,0,6,0,2,2,0,0,0,0,0,2),nrow=5, byrow =TRUE)

#Test
test_that("should work", {expect_equal(getCountLGR(CARDINALITY_EVENTS = 5, totalFreq3Grams1), test1ExpResult)})