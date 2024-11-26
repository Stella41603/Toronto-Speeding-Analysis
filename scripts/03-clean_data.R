#### Preamble ####
# Purpose: Cleans the raw dataset.
# Author: Xingjie Yao
# Date: 26 November 2024
# Contact: xingjie.yao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have ”arrow", "janitor", "tidyverse" packages installed and loaded
# Any other information needed? Make sure you are in the MobileWatchYourSpeedProgramAnalysis .RPROJ environment

#### Workspace setup ####
library(tidyverse)
library(arrow)
library(janitor)

#### Clean data ####
raw_data <- read_csv("data/01-raw_data/raw_data.csv")

cleaned_data <-
  raw_data %>%
  # Select only the relevant columns: "direction", "spd_100_and_above", and "pct_50"
  select(direction, spd_100_and_above, pct_50) %>%
  # Filter the dataset to include only rows where "direction" is one of "EB", "NB", "SB", or "WB"
  filter(direction %in% c("EB", "NB", "SB", "WB")) %>%
  filter(spd_100_and_above <= 500) %>%
  # Remove any rows with missing (NA) values in the selected columns
  tidyr::drop_na() %>%
  # Clean column names to be consistent and follow a standardized naming convention
  janitor::clean_names()

#### Save data ####
write_parquet(cleaned_data, "data/02-analysis_data/analysis_data.parquet")
