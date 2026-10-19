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
source(sprintf("%s/scripts/calcNormInsMatrix.R", getwd()))

#TEST 1 from testdata.csv
#Inputs
normVector1 <- c(10,20,16,10,2)
countRGL <- matrix(c(0,2,2,6,0,12,0,6,2,0,2,8,0,6,0,2,2,6,0,0,2,0,0,0,0),nrow=5, byrow =TRUE)

#Expected
test1ExpResult <- matrix(c(0,0.2,0.2,0.6,0,0.6,0,0.3,0.1,0,0.125,0.5,0,0.375,0,0.2,0.2,0.6,0,0,1,0,0,0,0), nrow =5, byrow =TRUE)

#Test
test_that("should work", {expect_equal(calcNormInsMatrix(normVector1, countRGL), test1ExpResult)})

#TEST 2 simple 2x2
#Inputs
normVector2 <- c(2,2)
count2 <- matrix(c(1,1,1,1), nrow=2, byrow = TRUE)

#Output
test2ExpResult <- matrix(1/2, 2, 2)
test_that("should work", {expect_equal(calcNormInsMatrix(normVector2, count2), test2ExpResult)})