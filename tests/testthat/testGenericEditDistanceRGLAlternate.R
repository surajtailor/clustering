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
source(sprintf("%s/scripts/getGenericEditDistanceRGLAlternate.R", getwd()))
  
#TEST 1 unit cost.
#Input
sequences<-c("1-2-3-4","2-3-4")
insRGLMatrix<-matrix(1, 4, 4)
subsMatrix <- matrix(1, 4, 4)

#Expected
expectedDistance<-matrix(c(8/3,7/3,7/3,6/2), 2, 2)

#Test
test_that("should work", {expect_equal(getGenericEditDistanceRGLAlternate(sequences, insRGLMatrix, subsMatrix), expectedDistance)})

#TEST 2 unit cost.
#Input
sequences2<-c("1-2-3-4","2-3-4")
insRGLMatrix2<-matrix(1, 4, 4)
subsMatrix2 <- matrix(2, 4, 4)

#Expected
expectedDistance2<-matrix(c(8/6,7/5,7/5,6/4), 2, 2)

#TEST 3 unit cost
test_that("should work", {expect_equal(getGenericEditDistanceRGLAlternate(sequences2, insRGLMatrix2, subsMatrix2), expectedDistance2)})

#Test
#Input
sequence3<-c("1-2-3-4-5-6-7-8","3-5-6-7")
insRGLMatrix3 <- matrix(1,8,8)
subsMatrix3 <- matrix(1,8,8)
diag(subsMatrix3)<-0

#Expected
expectedDistance3 <- matrix(c(0,3,3,0),2,2)

#Test
test_that("should work", {expect_equal(getGenericEditDistanceRGLAlternate(sequence3,insRGLMatrix3,subsMatrix3), expectedDistance3)})
