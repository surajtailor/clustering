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
source(sprintf("%s/scripts/calcSubsMatrix.R", getwd()))

#TEST 1 Matrix of Zeros 3x3
#Input
normalizedCoCount1 <- matrix(1/9,3,3)
coCountExpMatrix1 <- matrix(c(1/9,2/9,2/9,2/9,1/9,2/9,2/9,2/9,1/9),3,3)

#Expected
test1ExpResult <- matrix(c(log(1,2),log(.5,2),log(.5,2),log(.5,2),log(1,2),log(.5,2),log(.5,2),log(.5,2),log(1,2)),nrow=3, byrow =TRUE)

#Test
test_that("should work", {expect_equal(calcSubsMatrix(normalizedCoCount1,coCountExpMatrix1), test1ExpResult)})

#TEST 2
#Input
coCount2 <- matrix(c(17,24,52,16,0,24,62,32,56,4,52,32,44,20,0,16,56,20,17,0,0,4,0,0,1),nrow=5, byrow = TRUE)
#normalizedcocount matrix
x <- coCount2/sum(coCount2)
#probability vector
prob3 <- matrix(rowSums(x),5,1)

#expected matrix
y <- matrix(c(prob3[1]*prob3[1], 2*prob3[1]*prob3[2],2*prob3[1]*prob3[3],2*prob3[1]*prob3[4],2*prob3[1]*prob3[5],
                           2*prob3[2]*prob3[1], prob3[2]*prob3[2], 2*prob3[2]*prob3[3], 2*prob3[2]*prob3[4], 2*prob3[2]*prob3[5],
                           2*prob3[3]*prob3[1], 2*prob3[3]*prob3[2], prob3[3]*prob3[3], 2*prob3[3]*prob3[4], 2*prob3[3]*prob3[5],
                           2*prob3[4]*prob3[1], 2*prob3[4]*prob3[2], 2*prob3[4]*prob3[3], prob3[4]*prob3[4], 2*prob3[4]*prob3[5],
                           2*prob3[5]*prob3[1], 2*prob3[5]*prob3[2], 2*prob3[5]*prob3[3], 2*prob3[5]*prob3[4], prob3[5]*prob3[5]), nrow=5, byrow=TRUE)

#Expected
test2ExpResult <- matrix(c(log(x[1,1]/y[1,1],2),log(x[1,2]/y[1,2],2),log(x[1,3]/y[1,3],2),log(x[1,4]/y[1,4],2),-log(1/y[1,5],2),
                           log(x[2,1]/y[2,1],2),log(x[2,2]/y[2,2],2),log(x[2,3]/y[2,3],2),log(x[2,4]/y[2,4],2),log(x[2,5]/y[2,5],2),
                           log(x[3,1]/y[3,1],2),log(x[3,2]/y[3,2],2),log(x[3,3]/y[3,3],2),log(x[3,4]/y[3,4],2),-log(1/y[3,5],2),
                           log(x[4,1]/y[4,1],2),log(x[4,2]/y[4,2],2),log(x[4,3]/y[4,3],2),log(x[4,4]/y[4,4],2),-log(1/y[4,5],2),
                           -log(1/y[5,1],2),log(x[5,2]/y[5,2],2),-log(1/y[5,3],2),-log(1/y[5,4],2),log(x[5,5]/y[5,5],2)), nrow=5, byrow = TRUE)

#Test
test_that("should work", {expect_equal(calcSubsMatrix(x,y), test2ExpResult)})