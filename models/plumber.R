#### Preamble ####
# Purpose: Creates an API for model prediction.
# Author: Xingjie Yao
# Date: 26 November 2024
# Contact: xingjie.yao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have "tidyverse", "plumber", and "rstanarm" packages installed and loaded
# Any other information needed? Make sure you are in the MobileWatchYourSpeedProgramAnalysis .RPROJ environment and click "Run API" to start the API.

library(plumber)
library(rstanarm)
library(tidyverse)

# Load the model
model <- readRDS("first_model.rds")

# Define the model version
version_number <- "0.0.1"

# Define the variables
variables <- list(
  spd_100_and_above = "The count of vehicles with speed over 100 km/h, numeric value.",
  direction = "The cardinal direction of travel"
)

#* @param spd_100_and_above
#* @param direction
#* @get /predict_median_speed
predict_median_speed <- function(spd_100_and_above = 500, direction = "NB") {
  # Convert inputs to appropriate types
  spd_100_and_above <- as.numeric(spd_100_and_above)
  direction <- as.character(direction)

  # Prepare the df as a data frame
  df <- data.frame(
    spd_100_and_above = spd_100_and_above,
    direction = direction
  )

  # Extract posterior samples
  posterior_samples <- as.matrix(model) # Convert to matrix for easier manipulation

  # Define the generative process for prediction
  beta_NB <- posterior_samples[, "directionNB"]
  beta_SB <- posterior_samples[, "directionSB"]
  beta_WB <- posterior_samples[, "directionWB"]
  beta_spd100 <- posterior_samples[, "spd_100_and_above"]
  alpha <- posterior_samples[, "(Intercept)"]

  # Compute the predicted value for the observation
  predicted_values <- alpha +
    beta_NB * ifelse(df$direction == "NB", 1, 0) +
    beta_SB * ifelse(df$direction == "SB", 1, 0) +
    beta_WB * ifelse(df$direction == "WB", 1, 0) +
    beta_spd100 * df$spd_100_and_above

  # Predict
  mean_prediction <- mean(predicted_values)

  # Store results
  result <- list(
    "estimated_median_speed (km/h)" = mean_prediction
  )

  return(result)
}
