# Setup.R
# This script configures the lockfile for the project and installs the required packages

# Install renv package (renv is used to manage project dependencies)
install.packages("renv")

# Initialise renv for the project
renv::init()

# Install required packages
requried_packages = c("tidyr", "dplyr", "ggplot2")
renv::install(requried_packages)

# Snapshot the current project library (creates a lockfile)
renv::snapshot(packages = requried_packages)
