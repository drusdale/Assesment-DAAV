# Initialise packrat for the project
if (!require("packrat")) install.packages("packrat")
packrat::init()

# Install required packages
# Packrat will track these installations
install.packages(c(
  "tidyverse",   # Collection of data science packages
  "dplyr",       # Data manipulation functions
  "ggplot2",     # Creating visualizations
  "farver",      # Required for color manipulation in ggplot2
  "scales",      # Often needed with ggplot2
  "lifecycle"    # For handling deprecated features
))

# Take a snapshot of the current state
packrat::snapshot()

# Create .Rprofile to ensure packrat is used
cat('
# Load packrat
if (requireNamespace("packrat", quietly = TRUE)) {
  message("Loading packrat...")
  packrat::on()
}
', file = ".Rprofile")