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
source(sprintf("%s/scripts/getGenericEditDistanceRGL.R", getwd()))
  
#TEST 1 unit cost.
#Input
sequences<-c("1-2-3-4","2-3-4")
insRGLMatrix<-matrix(1, 4, 4)
subsMatrix <- matrix(1, 4, 4)

#Expected
expectedDistance<-matrix(c(8/7,7/6,7/6,6/5), 2, 2)

#Test
test_that("should work", {expect_equal(getGenericEditDistanceRGL(sequences, insRGLMatrix, subsMatrix), expectedDistance)})

#TEST 2 unit cost.
#Input
sequences2<-c("1-2-3-4","2-3-4")
insRGLMatrix2<-matrix(1, 4, 4)
subsMatrix2 <- matrix(2, 4, 4)

#Expected
expectedDistance2<-matrix(c(1,1,1,1), 2, 2)

#TEST 3 unit cost
test_that("should work", {expect_equal(getGenericEditDistanceRGL(sequences2, insRGLMatrix2, subsMatrix2), expectedDistance2)})

#Test
#Input
sequence3<-c("1-2-3-4-5-6-7-8","3-5-6-7")
insRGLMatrix3 <- matrix(1,8,8)
subsMatrix3 <- matrix(1,8,8)

#Expected
expectedDistance3 <- matrix(c(16/15,12/11,12/11,8/7),2,2)

#Test
test_that("should work", {expect_equal(getGenericEditDistanceRGL(sequence3,insRGLMatrix3,subsMatrix3), expectedDistance3)})

#TEST 4 identity
#input
sequence4<-c("1-2-3-4-5-6-7-8","1-2-3-4")
insRGLMatrix4 <- diag(8)
subsMatrix4 <- diag(8)

#expected
expectedDistance4 <- matrix(c(2,3,3,2),2,2)

#Test
test_that("should work", {expect_equal(getGenericEditDistanceRGL(sequence4, insRGLMatrix4, subsMatrix4),expectedDistance4)})

#TEST 5 all different costs
sequence5 <- c("1-2-3","1-2-4")
subsMatrix5 <- matrix(c(1,2,3,4,2,5,6,7,3,6,8,9,4,7,9,10), 4, 4)
insRGLMatrix5 <- matrix(c(11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26),4,4, byrow=TRUE)

#expected
expectedDistance5 <- matrix(c(6/71,6/75,6/75,6/79),2,2)

test_that("should work", {expect_equal(getGenericEditDistanceRGL(sequence5, insRGLMatrix5, subsMatrix5), expectedDistance5)})