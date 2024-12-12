#### Preamble ####
# Purpose: Simulates the analysis dataset.
# Author: Xingjie Yao
# Date: 26 November 2024
# Contact: xingjie.yao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have "tidyverse" packages installed and loaded
# Any other information needed? Make sure you are in the "Toronto_Speeding_Analysis.RPROJ" environment


#### Workspace setup ####
library(tidyverse)
set.seed(853)

#### Simulate data ####
simulated_data <- data.frame(
  direction = sample(c("EB", "NB", "SB", "WB"), size = 100, replace = TRUE) # Traffic directions
) %>%
  # Add spd_100_and_above with different probabilities based on direction
  mutate(spd_100_and_above = case_when(
    direction == "EB" ~ sample(0:50, size = 100, replace = TRUE, prob = c(rep(0.9, 11), rep(0.1, 40))), # EB: fewer high-speed vehicles
    direction == "WB" ~ sample(0:50, size = 100, replace = TRUE, prob = c(rep(0.7, 11), rep(0.3, 40))), # WB: moderate high-speed vehicles
    TRUE ~ sample(0:50, size = 100, replace = TRUE, prob = c(rep(0.8, 11), rep(0.2, 40)))              # NB/SB: default probabilities
  )) %>%
  # Simulate pct_50 with different mean speeds based on direction
  mutate(pct_50 = case_when(
    direction == "NB" ~ round(rnorm(100, mean = 50, sd = 5)), # NB: higher median speed
    direction == "SB" ~ round(rnorm(100, mean = 40, sd = 5)), # SB: lower median speed
    TRUE ~ round(rnorm(100, mean = 45, sd = 5))               # EB/WB: average median speed
  )) %>%
  # Ensure pct_50 stays within a reasonable range
  mutate(pct_50 = ifelse(pct_50 < 30, 30, ifelse(pct_50 > 60, 60, pct_50)))

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
