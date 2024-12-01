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

### Model comparison (compare prediction power)

# Split the data into training (80%) and testing (20%) sets
set.seed(853)  # For reproducibility
n <- nrow(analysis_data)
train_indices <- sample(1:n, size = floor(0.8 * n))  # Randomly select 80% of rows for training
train_data <- analysis_data[train_indices, ]
test_data <- analysis_data[-train_indices, ]

# Fit models on the training set
Bayesian_model <- stan_glm(
  formula = pct_50 ~ direction + spd_100_and_above,
  data = train_data,
  family = gaussian(),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 853
)

Frequentist_model <- lm(pct_50 ~ direction + spd_100_and_above, data = train_data)

# Define a function for evaluation metrics
evaluate_model <- function(model, data, response, type = "frequentist") {
  if (type == "bayesian") {
    # Use posterior_predict and compute column means for predicted values
    predictions <- posterior_predict(model, newdata = data)
    predicted_mean <- colMeans(predictions)  # Aggregate predictions
  } else {
    # Use predict for frequentist model
    predicted_mean <- predict(model, newdata = data)
  }
  # Extract true values
  true_values <- data[[response]]
  
  # Ensure lengths match
  if (length(true_values) != length(predicted_mean)) {
    stop("Mismatch in lengths of true_values and predicted_mean")
  }
  
  # Calculate RMSE and MAE
  rmse <- sqrt(mean((true_values - predicted_mean)^2))
  mae <- mean(abs(true_values - predicted_mean))
  
  return(list(RMSE = rmse, MAE = mae))
}


# Evaluate models on the testing set
bayesian_metrics <- evaluate_model(Bayesian_model, test_data, "pct_50", type = "bayesian")
frequentist_metrics <- evaluate_model(Frequentist_model, test_data, "pct_50", type = "frequentist")

# Display results
bayesian_metrics <- as.data.frame(bayesian_metrics)
frequentist_metrics <- as.data.frame(frequentist_metrics)
accuracy_comparison <- rbind(
  Bayesian = bayesian_metrics,
  Frequentist = frequentist_metrics
)

print(accuracy_comparison)

#### Save model ####
saveRDS(
  Bayesian_model,
  file = "models/Bayesian_model.rds"
)

saveRDS(
  Frequentist_model,
  file = "models/Frequentist_model.rds"
)
