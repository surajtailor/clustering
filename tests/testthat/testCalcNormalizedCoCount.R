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
source(sprintf("%s/scripts/calcNormalizedCoCount.R", getwd()))

#TEST 1 Matrix of Zeros 3x3
#Input
coCount1<-matrix(c(0,0,0,0,0,0,0,0,0),nrow=3, byrow = TRUE)

#Output
test1ExpResult <- "Norm Value = 0. Check your data."

#Test
test_that("should work", {expect_equal(calcNormalizedCoCount(coCount1), test1ExpResult)})

#TEST 2 Matrix of 1s 3x3
#Input
coCount2<-matrix(c(1,1,1,1,1,1,1,1,1),nrow=3, byrow = TRUE)

#Output
test2ExpResult <- matrix(1/9, 3, 3)

#Test
test_that("should work", {expect_equal(calcNormalizedCoCount(coCount2), test2ExpResult)})

#TEST 3 Matrix of Zeros 5x5
#Input
coCount3 <- matrix(c(17,24,52,16,0,24,62,32,56,4,52,32,44,20,0,16,56,20,17,0,0,4,0,0,1),nrow=5, byrow = TRUE)

#Output
test3ExpResult <- coCount3/sum(coCount3)

#Test
test_that("should work", {expect_equal(calcNormalizedCoCount(coCount3), test3ExpResult)})