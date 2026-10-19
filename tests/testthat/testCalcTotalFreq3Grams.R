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
source(sprintf("%s/scripts/calcTotalFreq3Grams.R", getwd()))

#TEST 1 using testdata.csv
#Input
id_uniqueSeq <- c(1,2,3,4,4,5,5,6,6,7,7,8,8,9,9,9,9,10,10,10,10,11,12,13,14)
frequency <- c(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)
sequence <- c('1','1-2','1-2-3','1-2-3-4','1-2-3-4','4-1-2-3','4-1-2-3','3-4-1-2','3-4-1-2','2-3-4-1','2-3-4-1','4-3-2-1','4-3-2-1','1-2-3-4-1-2-3-4','1-2-3-4-1-2-3-4','1-2-3-4-1-2-3-4','1-2-3-4-1-2-3-4','4-3-2-1-4-3-2-1','4-3-2-1-4-3-2-1','4-3-2-1-4-3-2-1','4-3-2-1-4-3-2-1','1-3-3','2-4-4','3-1-1','4-2-2')
ngram <- c('1 5 5 ', '1 2 5 ', '1 2 3 ', '2 3 4 ', '1 2 3 ', '4 1 2 ', '1 2 3 ', '4 1 2 ', '3 4 1 ', '2 3 4 ', '3 4 1 ', '4 3 2 ', '3 2 1 ', '2 3 4 ', '1 2 3 ', '4 1 2 ', '3 4 1 ', '4 3 2 ', '3 2 1 ', '2 1 4 ', '1 4 3 ', '1 3 3 ', '2 4 4 ', '3 1 1 ', '4 2 2 ')
freq <- c(1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,2,2,1,1,1,1,1,1)
prop <- c(1.00000000,1.00000000,1.00000000,0.5000000,0.5000000,0.5000000,0.5000000,0.5000000,0.5000000,0.5000000,0.5000000,0.5000000,0.5000000,1/3,1/3,1/6,1/6,1/3,1/3,1/6,1/6,1.0000000,1.0000000,1.0000000,1.0000000)
gramfrequency<-c(2,2,2,2,2,2,2,2,2,2,2,2,2,4,4,2,2,4,4,2,2,2,2,2,2)
gramDataFrame1 <- data.frame(id_uniqueSeq, frequency, sequence, ngram, freq, prop, gramfrequency) 

splitSeq <- c('1 5 5 ', '1 2 5 ', '1 2 3 ', '2 3 4 ', '4 1 2 ', '3 4 1 ', '4 3 2 ', '3 2 1 ', '2 1 4 ', '1 4 3 ', '1 3 3 ', '2 4 4 ', '3 1 1 ', '4 2 2 ')

#Output
frequency <- c(2,2,10,8,6,6,6,6,2,2,2,2,2,2)
uniqueThreeGrams <- splitSeq
test1ExpResult <- data.frame(uniqueThreeGrams, frequency)

#Tests
test_that("should work", {expect_equal(calcTotalFreq3Grams(gramDataFrame1, splitSeq), test1ExpResult)})