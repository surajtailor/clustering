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
source(sprintf("%s/scripts/calcInsNormVector.R", getwd()))

#TEST 1 from testdata.csv
#Inputs
countRGL <- matrix(c(0,2,2,6,0,12,0,6,2,0,2,8,0,6,0,2,2,6,0,0,2,0,0,0,0),nrow=5, byrow =TRUE)

#Expected
test1ExpResult <- c(10,20,16,10,2)

#Test
test_that("should work", {expect_equal(calcInsNormVector(countRGL), test1ExpResult)})

#TEST 2
#Inputs
count2 <- matrix(1,2,2)

#Expected
test2ExpResult <- c(2,2)

#Test
test_that("should work", {expect_equal(calcInsNormVector(count2), test2ExpResult)})