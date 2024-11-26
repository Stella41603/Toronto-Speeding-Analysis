#### Preamble ####
# Purpose: Simulates the analysis dataset.
# Author: Xingjie Yao
# Date: 26 November 2024
# Contact: xingjie.yao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have "tidyverse" packages installed and loaded
# Any other information needed? Make sure you are in the MobileWatchYourSpeedProgramAnalysis .RPROJ environment


#### Workspace setup ####
library(tidyverse)
set.seed(853)

#### Simulate data ####
# Simulate the dataset
simulated_data <- data.frame(
  direction = sample(c("EB", "NB", "SB", "WB"), size = 100, replace = TRUE), # Traffic directions
  spd_100_and_above = sample(0:50, size = 100, replace = TRUE, prob = c(rep(0.8, 11), rep(0.2, 40))), # Skewed towards fewer high-speed vehicles
  pct_50 = round(rnorm(100, mean = 45, sd = 5)) # Simulating median speeds around 45 km/h with some variation
)
# Ensure pct_50 stays within a reasonable range
simulated_data <- simulated_data %>%
  mutate(pct_50 = ifelse(pct_50 < 30, 30, ifelse(pct_50 > 60, 60, pct_50)))

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
