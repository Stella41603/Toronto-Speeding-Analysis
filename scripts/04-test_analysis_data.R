#### Preamble ####
# Purpose: Tests the validity and structure of the analysis dataset.
# Author: Xingjie Yao
# Date: 26 November 2024
# Contact: xingjie.yao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have "tidyverse" and "testthat" packages installed and loaded
# Any other information needed? Make sure you are in the MobileWatchYourSpeedProgramAnalysis .RPROJ environment


#### Workspace setup ####
library(tidyverse)
library(testthat)

data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

#### Test data ####
# 1. Test that `direction` only contains valid traffic directions
test_that("Direction column contains only valid traffic directions", {
  valid_directions <- c("EB", "NB", "SB", "WB")
  expect_true(all(data$direction %in% valid_directions))
})

# 2. Test that `spd_100_and_above` contains valid counts of vehicles
test_that("spd_100_and_above contains valid counts of vehicles", {
  expect_true(all(data$spd_100_and_above >= 0 & data$spd_100_and_above <= 500)) # Count is within range
  expect_true(all(data$spd_100_and_above == as.integer(data$spd_100_and_above))) # Count is an integer
})

# 3. Test that `pct_50` is a valid 50th percentile speed between 0 and 80
test_that("pct_50 is within the valid range for median speed", {
  expect_true(all(data$pct_50 >= 0 & data$pct_50 <= 80)) # Speed percentile is within range
})
