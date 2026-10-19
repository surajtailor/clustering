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
source(sprintf("%s/scripts/getGowerDistanceTest.R", getwd()))

#TEST 1
#Input1
seqDistances <-matrix(c(0, 1, 1, 0), 2, 2)

#Input2
age <- c(1,2)
gender <- c('M','F')
gender <- as.factor(gender)
civil_status <- c('MARRIED','SINGLE')
civil_status <- as.factor(civil_status)
has_children <-c (TRUE,FALSE)
sample.data <- data.frame(age, gender, civil_status, has_children)

#Input3 (non empty)
splitSeq <- c("1-3-3", "1-2-3")

#Expected
test1ExpResult <- matrix(c(0, 1, 1, 0), 2, 2)

#Test
test_that("should work", {all.equal(getGowerDistanceTest(seqDistances, sample.data, splitSeq), test1ExpResult)})