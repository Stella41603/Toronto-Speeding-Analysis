#### Preamble ####
# Purpose: Facilitates the API for model prediction.
# Author: Xingjie Yao
# Date: 26 November 2024
# Contact: xingjie.yao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have "plumber" package installed and loaded
# Any other information needed? Make sure you are in the MobileWatchYourSpeedProgramAnalysis .RPROJ environment and 
# use "plumber.R" to access the API.

library(plumber)

serve_model <- plumb("models/plumber.R")
serve_model$run(port = 8000)
