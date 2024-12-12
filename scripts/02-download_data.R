#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto Portal.
# Author: Xingjie Yao
# Date: 26 November 2024
# Contact: xingjie.yao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have ”opendatatoronto" and "tidyverse" packages installed and loaded
# Any other information needed? Make sure you are in the "Toronto_Speeding_Analysis.RPROJ" environment


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

#### Download data ####
# get package
package <- show_package("058236d2-d26e-4622-9665-941b9e7a5229")
# get all resources for this package
resources <- list_package_resources("058236d2-d26e-4622-9665-941b9e7a5229")
# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c("csv", "geojson"))
# load the first datastore resource as a sample
data <- filter(datastore_resources, row_number() == 1) %>% get_resource()

#### Save data ####
# change the_raw_data to whatever name you assigned when you downloaded it.
write_csv(data, "data/01-raw_data/raw_data.csv")
