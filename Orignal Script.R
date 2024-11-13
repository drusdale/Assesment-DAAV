# Install and load necessary packages
install.packages("tidyverse")
install.packages("dplyr")
install.packages("ggplot2")

library(tidyverse)
library(dplyr)
library(ggplot2)

# Load the raw data (ensure you have the correct path for the RData file)
load("RawData/OSF_WFH.RData")

data_frame <- OSF_WFH

# Columns to keep for analysis
columns_to_keep <- c("Single-item Scale Productivity Home", "Single-item Scale Work Satisfaction Home", 
                     "Ventilation Cat", "Home Office Light", 
                     "Pet - Dog", "Pet - Cat", "geslacht")

# Filter and rename columns, removing rows with any NA values
filtered_data <- data_frame %>%
  select(all_of(columns_to_keep)) %>%
  rename(
    Productivity = `Single-item Scale Productivity Home`,
    Satisfaction = `Single-item Scale Work Satisfaction Home`
  ) %>%
  # Create binary columns for 'Dog', 'Cat', and Ventilation
  mutate(
    `High Ventilation` = case_when(
      `Ventilation Cat` == "High Ventilation" ~ 1,
      TRUE ~ 0
    ),
    `Medium Ventilation` = case_when(
      `Ventilation Cat` == "Medium Ventilation" ~ 1,
      TRUE ~ 0
    ),
    `Low Ventilation` = case_when(
      `Ventilation Cat` == "Low Ventilation" ~ 1,
      TRUE ~ 0
    ),
    `Natural Home Office Light` = case_when(
      `Home Office Light` == "Natural" ~ 1,
      TRUE ~ 0
    ),
    `Average Home Office Light` = case_when(
      `Home Office Light` == "Average" ~ 1,
      TRUE ~ 0
    ),
    `No Natural Home Office Light` = case_when(
      `Home Office Light` == "No Natural" ~ 1,
      TRUE ~ 0
    ),
    Dog = case_when(
      `Pet - Dog` == "Yes" ~ 1,
      TRUE ~ 0
    ),
    `No Dog` = case_when(
      `Pet - Dog` == "No" ~ 1,
      TRUE ~ 0
    ),
    Cat = case_when(
      `Pet - Cat` == "Yes" ~ 1,
      TRUE ~ 0
    ),
    `No Cat` = case_when(
      `Pet - Cat` == "No" ~ 1,
      TRUE ~ 0
    ),
    `Male` = case_when(
      `geslacht` == 'Male' ~ 1,
      TRUE ~ 0
    ),
    `Female` = case_when(
      `geslacht` == 'Female' ~ 1,
      TRUE ~ 0
    )
  ) %>%
  drop_na()

# Create a data frame to hold the calculated results
calculated_data <- data.frame()

# Loop over columns to calculate means
for (col in colnames(filtered_data)) {
  calculated_output <- filtered_data %>%
    group_by(across(all_of(col))) %>%
    summarise(
      mean_productivity = mean(Productivity),
      mean_satisfaction = mean(Satisfaction)
    ) %>%
    ungroup()
  
  # Add the column name as a variable in the output
  calculated_output$variable <- col
  
  # Rename the dynamically grouped column to "value" for easier reading
  colnames(calculated_output)[1] <- "value"
  
  # Convert 'value' column to character to avoid type mismatch in bind_rows()
  calculated_output$value <- as.character(calculated_output$value)
  
  # Combine the results
  calculated_data <- bind_rows(calculated_data, calculated_output)
}

# Reshaping the data for dual-axis plotting with a new name for the reshaped column
calculated_data_long <- calculated_data %>%
  pivot_longer(cols = c(mean_productivity, mean_satisfaction),
               names_to = "measure", values_to = "score") %>%
  mutate(measure = factor(measure, levels = c("mean_productivity", "mean_satisfaction"), 
                          labels = c("Productivity", "Satisfaction")))

# Specify the order of the variables in the legend
var_order <- c("High Ventilation", "Medium Ventilation", "Low Ventilation",
               "Natural Home Office Light", "Average Home Office Light", "No Natural Home Office Light",
               "Dog", "No Dog", "Cat", "No Cat", "Male", "Female")

# Create a bar chart with both Productivity and Satisfaction scores
ggplot(calculated_data_long, aes(x = score, y = measure, fill = factor(variable, levels = var_order))) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  scale_y_discrete(name = "Measure") +
  scale_x_continuous(
    name = "Score",
    breaks = seq(1, 10, 1),
    limits = c(0, 10)
  ) +
  scale_fill_discrete(name = "Variable") +
  theme_minimal() +
  labs(
    title = "Productivity and Work Satisfaction by Variable",
    x = "Score",
    y = "Measure"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))