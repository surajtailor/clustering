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
source(sprintf("%s/scripts/calcCoCountExpMatrix.R", getwd()))

#TEST 1 Matrix of Zeros 3x3
#Input
coCountProbVector1 <- matrix(1/3,3,1)

#Output
test1ExpResult <- matrix(c(1/9,2/9,2/9,2/9,1/9,2/9,2/9,2/9,1/9),3,3)

#Test
test_that("should work", {expect_equal(calcCoCountExpMatrix(coCountProbVector1), test1ExpResult)})

#TEST 2 
#Input
coCount3 <- matrix(c(17,24,52,16,0,24,62,32,56,4,52,32,44,20,0,16,56,20,17,0,0,4,0,0,1),nrow=5, byrow = TRUE)
normalizedCoCount3 <- coCount3/sum(coCount3)
prob3 <- matrix(rowSums(normalizedCoCount3),5,1)

#Output
test2ExpResult <- matrix(c(prob3[1]*prob3[1], 2*prob3[1]*prob3[2],2*prob3[1]*prob3[3],2*prob3[1]*prob3[4],2*prob3[1]*prob3[5],
                           2*prob3[2]*prob3[1], prob3[2]*prob3[2], 2*prob3[2]*prob3[3], 2*prob3[2]*prob3[4], 2*prob3[2]*prob3[5],
                           2*prob3[3]*prob3[1], 2*prob3[3]*prob3[2], prob3[3]*prob3[3], 2*prob3[3]*prob3[4], 2*prob3[3]*prob3[5],
                           2*prob3[4]*prob3[1], 2*prob3[4]*prob3[2], 2*prob3[4]*prob3[3], prob3[4]*prob3[4], 2*prob3[4]*prob3[5],
                           2*prob3[5]*prob3[1], 2*prob3[5]*prob3[2], 2*prob3[5]*prob3[3], 2*prob3[5]*prob3[4], prob3[5]*prob3[5]), nrow=5, byrow=TRUE)

#Test
test_that("should work", {expect_equal(calcCoCountExpMatrix(prob3), test2ExpResult)})