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
source(sprintf("%s/scripts/getGenericEditDistance.R", getwd()))

#TEST 1
test_that("unit cost", {
  sequences<-c("1-2-3-4-5","2-3-5-6")
  insRGLMatrix<-as.matrix(c(1,1,1))
  resultDistance <- functionGenericEditDistance(sequences, insRGLMatrix, insLGRMatrix, subsMatrix, 2)
  expectedDistance<-as.matrix(c(2,1,3,4,5))
  expect_equal(resultDistance, expectedDistance)
})