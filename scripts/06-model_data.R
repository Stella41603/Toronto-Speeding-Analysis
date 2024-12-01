#### Preamble ####
# Purpose: Builds a Bayesian linear regression model to predict median speed with direction of travel and number of speeding cars
# Author: Xingjie Yao
# Date: 26 November 2024
# Contact: xingjie.yao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have "tidyverse", "arrow , and "rstanarm“ packages installed and loaded
# Any other information needed? Make sure you are in the MobileWatchYourSpeedProgramAnalysis .RPROJ environment

#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

### Model data ####
Bayesian_model <-
  stan_glm(
    formula = pct_50 ~ direction + spd_100_and_above,
    data = analysis_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 853
  )

Frequentist_model <- lm(pct_50 ~ direction + spd_100_and_above, data = analysis_data)


#### Save model ####
saveRDS(
  Bayesian_model,
  file = "models/Bayesian_model.rds"
)
