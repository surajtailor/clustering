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

#Source files
setwd("..")
setwd("..")
source(sprintf("%s/scripts/calcInsMatrix2.R", getwd()))
source(sprintf("%s/scripts/calcInsProbVector.R", getwd()))
source(sprintf("%s/scripts/calcInsNormVector.R", getwd()))

#TEST 1
#Inputs
prob1 <- c(.5,.5)
normInsMatrix1 <- matrix(1/2,2,2)
count1 <- matrix(c(1,1,1,1), nrow=2, byrow = TRUE)

#Expected
test1ExpResult <- matrix(c(log(0.5/(.5^2),2), log(0.5/(.5^2),2), log(0.5/(.5^2),2), log(0.5/(.5^2),2)), nrow=2, byrow = TRUE)

#Test
test_that("should work", {expect_equal(calcInsMatrix2(normInsMatrix1, prob1, count1), test1ExpResult)})

#TEST 2
#Inputs
prob2 <- c(.5, .5)
normInsMatrix2 <- matrix(c(1,0,1,0), nrow=2, byrow = TRUE)
count2 <- matrix(c(1,0,1,0), nrow=2, byrow = TRUE)
  
#Expected
test2ExpResult <- matrix(c(log(1/(.5^2),2), -log(1/(.5^2),2), log(1/(.5^2),2), -log(1/(.5^2),2)), nrow=2, byrow = TRUE)

#Test
test_that("should work", {expect_equal(calcInsMatrix2(normInsMatrix2, prob2, count2), test2ExpResult)})

#TEST 3
#Functions
normInsMatrix3 <- matrix(c(0,0.2,0.2,0.6,0,0.6,0,0.3,0.1,0,0.125,0.5,0,0.375,0,0.2,0.2,0.6,0,0,1,0,0,0,0), nrow =5, byrow =TRUE)
count3 <- matrix(c(0,2,2,6,0,12,0,6,2,0,2,8,0,6,0,2,2,6,0,0,2,0,0,0,0), nrow = 5, byrow = TRUE)
normVector3 <- calcInsNormVector(count3)
prob3 <- calcInsProbVector(normVector3)

#Expected
test3ExpResult <- matrix(c(-log(1/(prob3[1])^2,2), log(0.2/(prob3[1]*prob3[2]),2), log(0.2/(prob3[1]*prob3[3]),2), log(0.6/(prob3[1]*prob3[4]),2), -log(1/(prob3[1]*prob3[5]),2), 
                         log(0.6/(prob3[2]*prob3[1]),2), -log(1/(prob3[2]*prob3[2]),2), log(0.3/(prob3[2]*prob3[3]),2) , log(0.1/(prob3[2]*prob3[4]),2), -log(1/(prob3[2]*prob3[5]),2), 
                                                                                               log(0.125/(prob3[3]*prob3[1]),2), log(0.5/(prob3[3]*prob3[2]),2), -log(1/(prob3[3]*prob3[3]),2), log(0.375/(prob3[3]*prob3[4]),2), -log(1/(prob3[3]*prob3[5]),2),
log(0.2/(prob3[4]*prob3[1]),2), log(0.2/(prob3[4]*prob3[2]),2), log(0.6/(prob3[4]*prob3[3]),2), -log(1/(prob3[4]*prob3[4]),2), -log(1/(prob3[4]*prob3[5]),2),
log(1/(prob3[5]*prob3[1]),2), -log(1/(prob3[5]*prob3[2]),2), -log(1/(prob3[5]*prob3[3]),2), -log(1/(prob3[5]*prob3[4]),2), -log(1/(prob3[5]*prob3[5]),2)), nrow = 5, byrow = TRUE)

#Test
test_that("should work", {expect_equal(calcInsMatrix2(normInsMatrix3, prob3, count3), test3ExpResult)})