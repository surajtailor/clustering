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
source(sprintf("%s/scripts/getGenericEditDistanceLGR.R", getwd()))

#TEST 1 unit cost.
#Input
sequences<-c("1-2-3-4","2-3-4")
insLGRMatrix<-matrix(1, 4, 4)
subsMatrix <- matrix(1, 4, 4)

#Expected
expectedDistance<-matrix(c(8/7,7/6,7/6,6/5), 2, 2)

#Test
test_that("should work", {expect_equal(getGenericEditDistanceLGR(sequences, insLGRMatrix, subsMatrix), expectedDistance)})


#TEST 2 unit cost.
#Input
sequences2<-c("1-2-3-4","2-3-4")
insRGLMatrix2<-matrix(1, 4, 4)
subsMatrix2 <- matrix(2, 4, 4)

#Expected
expectedDistance2<-matrix(c(1,1,1,1), 2, 2)

#Test
test_that("should work", {expect_equal(getGenericEditDistanceLGR(sequences2, insRGLMatrix2, subsMatrix2), expectedDistance2)})