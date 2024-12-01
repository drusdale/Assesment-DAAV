# setup.R
install.packages("renv")

# Initialize renv for the project
renv::init()

# Install required packages
requried_packages = c("tidyr", "dplyr", "ggplot2")
renv::install(requried_packages)

# Snapshot the current project library
renv::snapshot(packages = requried_packages)
