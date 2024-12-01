# setup.R
install.packages("renv")

# Initialize renv for the project
renv::init()

# Install required packages
renv::install(c("tidyr", "dplyr", "ggplot2"))

# Snapshot the current project library
renv::snapshot()
