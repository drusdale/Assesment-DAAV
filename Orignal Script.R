#installing packages 
install.packages("tidyverse")
install.packages("dplyr")
install.packages("ggplot2")

#loading packages 
library(tidyverse)
library(dplyr)
library(ggplot2)

#Loading in raw data (source: OSF journal)
data_frame <- get(load("RawData/OSF_WFH.RData"))

#printing data into R (sanity check)
print(data_frame)

#visualizing column names to ensure the required columns exist in the R data file before mutation
print(colnames(data_frame))

#choosing which varibles to keep for data analysis 
columns_to_keep <- c("Single-item Scale Productivity Home", "Single-item Scale Work Satisfaction Home", "Ventilation Cat", "Where Work?", "Home Office Light", "Childern Home during Office Hours", "Pet - Dog", "Pet - Cat", "Partner Home during Office Hours", "geslacht")

# Filter and rename columns
filtered_data <- data_frame %>%
  select(all_of(columns_to_keep)) %>%
  rename(
    Productivity = `Single-item Scale Productivity Home`,
    Satisfaction = `Single-item Scale Work Satisfaction Home`,
    Ventilation = `Ventilation Cat`,
    Work_Location = `Where Work?`,
    Light = `Home Office Light`,
    Children_Home = `Childern Home during Office Hours`,
    Dog = `Pet - Dog`,
    Cat = `Pet - Cat`,
    Partner_Home = `Partner Home during Office Hours`,
    gender = geslacht
  )

#columns to put in graph
columns_to_calculate <- colnames(filtered_data)
  
#creating a data frame for columns to calculate 
calculated_data <- data.frame()

for (col in columns_to_calculate) {
  calculated_output <- filtered_data %>%
    group_by(across(all_of(col))) %>%
    summarise(
      mean_productivity = mean(Productivity, na.rm = TRUE),
      mean_satisfaction = mean(Satisfaction, na.rm = TRUE),
      .groups = 'drop'
    )
  
  # Add a column to identify the variable name
  calculated_output$variable <- col
  
  # Rename the dynamically grouped column to "value" for easier reading
  colnames(calculated_output)[1] <- "value"
  
  # Combine with calculated_data
  calculated_data <- bind_rows(calculated_data, calculated_output)
}


  