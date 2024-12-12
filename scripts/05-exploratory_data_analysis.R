#### Preamble ####
# Purpose: Performs exploratory data analysis on the analysis dataset.
# Author: Xingjie Yao
# Date: 26 November 2024
# Contact: xingjie.yao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have "tidyverse" package installed and loaded
# Any other information needed? Make sure you are in the "Toronto_Speeding_Analysis.RPROJ" environment


#### Workspace setup ####
library(tidyverse)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

# Boxplot for pct_50 by direction
ggplot(analysis_data, aes(x = direction, y = pct_50, fill = direction)) +
  geom_boxplot() +
  labs(
    title = "Boxplot of 50th Percentile Speed by Direction",
    x = "Direction",
    y = "50th Percentile Speed (km/h)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Scatterplot of spd_100_and_above vs pct_50
ggplot(analysis_data, aes(x = spd_100_and_above, y = pct_50, color = direction)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(
    title = "Scatterplot of Vehicles Over 100 km/h vs 50th Percentile Speed",
    x = "Count of Vehicles Over 100 km/h",
    y = "50th Percentile Speed (km/h)",
    color = "Direction"
  ) +
  theme_minimal() +
  theme(legend.position = "right")
