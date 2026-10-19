this.dir <- dirname(getActiveDocumentContext()$path)
setwd(this.dir)

#libraries
if (!require(testthat)) install.packages('testthat')
library(testthat)

#run a specific test
#test_file("testMyFunction.R")

#run all tests in this directory (tests/testthat)
test_dir("./")