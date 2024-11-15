# First, install packrat if not already installed
if (!require("packrat")) {
  install.packages("packrat")
}

# Initialise packrat in the current directory
packrat::init()

# Install all required packages
install.packages(c(
  "tidyverse",   # Collection of data science packages
  "dplyr",       # Data manipulation functions
  "ggplot2",     # Creating visualizations
  "farver",      # Required for color manipulation in ggplot2
  "scales",      # Often needed with ggplot2
  "lifecycle"    # For handling deprecated features
))

# Now restore the packages
packrat::restore()

# Load the libraries
library(tidyverse)
library(dplyr)
library(ggplot2)

print("Initialisation complete.")

# Check packrat status
print(packrat::status())