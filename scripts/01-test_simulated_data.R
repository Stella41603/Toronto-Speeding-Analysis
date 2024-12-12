#### Preamble ####
# Purpose: Tests the validity and structure of the simulated dataset.
# Author: Xingjie Yao
# Date: 26 November 2024
# Contact: xingjie.yao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have "tidyverse" and "testthat" packages installed and loaded
# Any other information needed? Make sure you are in the "Toronto_Speeding_Analysis.RPROJ" environment


#### Workspace setup ####
library(tidyverse)
library(testthat)


#### Test data ####
simulated_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# 1. Test that `direction` only contains valid traffic directions
test_that("Direction column contains only valid traffic directions", {
  valid_directions <- c("EB", "NB", "SB", "WB")
  expect_true(all(simulated_data$direction %in% valid_directions))
})

# 2. Test that `spd_100_and_above` contains valid counts of vehicles
test_that("spd_100_and_above contains valid counts of vehicles", {
  expect_true(all(simulated_data$spd_100_and_above >= 0 & simulated_data$spd_100_and_above <= 50)) # Count is within range
  expect_true(all(simulated_data$spd_100_and_above == as.integer(simulated_data$spd_100_and_above))) # Count is an integer
})

# 3. Test that `pct_50` is a valid 50th percentile speed between 30 and 60
test_that("pct_50 is within the valid range for median speed", {
  expect_true(all(simulated_data$pct_50 >= 30 & simulated_data$pct_50 <= 60)) # Speed percentile is within range
})
