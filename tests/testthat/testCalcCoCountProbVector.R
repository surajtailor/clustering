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
source(sprintf("%s/scripts/calcCoCountProbVector.R", getwd()))

#TEST 1 Matrix of Zeros 3x3
#Input
normalizedCoCount1 <- matrix(1/9, 3, 3)

#Output
test1ExpResult <- matrix(1/3,3,1)

#Test
test_that("should work", {expect_equal(calcCoCountProbVector(normalizedCoCount1), test1ExpResult)})

#TEST 2 Matrix
#Input
normalizedCoCount2 <- matrix(1/9, 3, 3)

#Output
test2ExpResult <- matrix(1/3,3,1)

#Test
test_that("should work", {expect_equal(calcCoCountProbVector(normalizedCoCount2), test2ExpResult)})

#TEST 3 Matrix
coCount3 <- matrix(c(17,24,52,16,0,24,62,32,56,4,52,32,44,20,0,16,56,20,17,0,0,4,0,0,1),nrow=5, byrow = TRUE)
normalizedCoCount3 <- coCount3/sum(coCount3)

#Output
test3ExpResult <- matrix(rowSums(normalizedCoCount3), 5,1)

#Test
test_that("should work", {expect_equal(calcCoCountProbVector(normalizedCoCount3), test3ExpResult)})