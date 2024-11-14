# Install and load necessary packages
install.packages("tidyverse")
install.packages("dplyr")
install.packages("ggplot2")

library(tidyverse)
library(dplyr)
library(ggplot2)

# Load the data
load("RawData/OSF_WFH.RData")
df = OSF_WFH

# Drop rows with NA values
nna_df = df %>% drop_na()

# Display the first few rows of the data
head(nna_df)

# Define the columns to keep
columns_to_keep <- c("Single-item Scale Productivity Home", "Single-item Scale Work Satisfaction Home",
                     "Ventilation Cat", "Home Office Light", "Where Work?", "Childern Home during Office Hours", "Partner Home during Office Hours",
                     "Pet - Dog", "Pet - Cat", "geslacht")

# Define the columns to keep after mutation
columns_to_keep_after_mutation <- c("Productivity", "Satisfaction", "High Ventilation", "Medium Ventilation", "Low Ventilation",
                                    "Natural Home Office Light", "Average Home Office Light", "No Natural Home Office Light",
                                    "Dog", "No Dog", "Cat", "No Cat", "Partner Always Home", "Partner Sometimes Home",
                                    "Partner Never Home", "No Partner", "Children Always Home", "Children Sometimes Home",
                                    "Children Never Home", "No Children", "WFH Partically", "WFH Exclusively")

# Select and mutate the data
nna_df <- nna_df %>%
  select(all_of(columns_to_keep)) %>%
  rename(
    Productivity = "Single-item Scale Productivity Home",
    Satisfaction = "Single-item Scale Work Satisfaction Home",
  ) %>%
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
    ),
    `Partner Always Home` = case_when(
      `Partner Home during Office Hours` == 'Always' ~ 1,
      TRUE ~ 0
    ),
    `Partner Sometimes Home` = case_when(
      `Partner Home during Office Hours` == 'Sometimes' ~ 1,
      TRUE ~ 0
    ),
    `Partner Never Home` = case_when(
      `Partner Home during Office Hours` == 'Never' ~ 1,
      TRUE ~ 0
    ),
    `No Partner` = case_when(
      `Partner Home during Office Hours` == 'No Partner' ~ 1,
      TRUE ~ 0
    ),
    `Children Always Home` = case_when(
      `Childern Home during Office Hours` == 'Always' ~ 1,
      TRUE ~ 0
    ),
    `Children Sometimes Home` = case_when(
      `Childern Home during Office Hours` == 'Sometimes' ~ 1,
      TRUE ~ 0
    ),
    `Children Never Home` = case_when(
      `Childern Home during Office Hours` == 'Never' ~ 1,
      TRUE ~ 0
    ),
    `No Children` = case_when(
      `Partner Home during Office Hours` == 'No Children' ~ 1,
      TRUE ~ 0
    ),
    `WFH Partically` = case_when(
      `Where Work?` == 'Partially Work' ~ 1,
      TRUE ~ 0
    ),
    `WFH Exclusively` = case_when(
      `Where Work?` == 'Exclusively Home' ~ 1,
      TRUE ~ 0
    )
  ) %>%
  select(all_of(columns_to_keep_after_mutation))

# Create bar data for the overall graph
cols <- columns_to_keep_after_mutation[3:length(columns_to_keep_after_mutation)]
bar_data <- data.frame()

for (col in cols) {
  temp <- nna_df %>%
    group_by(!!sym(col)) %>%
    summarise(
      Satisfaction = mean(Satisfaction, na.rm = TRUE),
      Productivity = mean(Productivity, na.rm = TRUE)
    ) %>%
    pivot_longer(cols = c(Satisfaction, Productivity), names_to = "Metric", values_to = "Value") %>%
    mutate(Variable = col)
  
  bar_data <- bind_rows(bar_data, temp)
}

# Define the order of variables
variable_order <- c("High Ventilation", "Medium Ventilation", "Low Ventilation",
                    "Natural Home Office Light", "Average Home Office Light", "No Natural Home Office Light",
                    "Dog", "No Dog", "Cat", "No Cat", "Partner Always Home", "Partner Sometimes Home",
                    "Partner Never Home", "No Partner", "Children Always Home", "Children Sometimes Home",
                    "Children Never Home", "No Children", "WFH Partically", "WFH Exclusively")

bar_data$Variable <- factor(bar_data$Variable, levels = variable_order)

# Create the overall graph
overall_plot <- ggplot(bar_data, aes(x = Variable, y = Value, fill = Metric)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Satisfaction and Productivity per Variable", x = "Variable", y = "Value") +
  theme_minimal() +
  coord_flip()

# Save the overall graph
dir.create("Graphs", showWarnings = FALSE)
ggsave("Graphs/overall_plot.png", plot = overall_plot, width = 10, height = 8)

# Define the categories and their corresponding variables
categories <- list(
  Ventilation = c("High Ventilation", "Medium Ventilation", "Low Ventilation"),
  Light = c("Natural Home Office Light", "Average Home Office Light", "No Natural Home Office Light"),
  Pets = c("Dog", "No Dog", "Cat", "No Cat"),
  Partner = c("Partner Always Home", "Partner Sometimes Home", "Partner Never Home", "No Partner"),
  Children = c("Children Always Home", "Children Sometimes Home", "Children Never Home", "No Children")
)

# Create and save individual graphs for each category
for (category in names(categories)) {
  category_vars <- categories[[category]]
  category_data <- bar_data %>% filter(Variable %in% category_vars)
  
  category_plot <- ggplot(category_data, aes(x = Variable, y = Value, fill = Metric)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = paste("Satisfaction and Productivity per", category), x = "Variable", y = "Value") +
    theme_minimal() +
    coord_flip()
  
  ggsave(paste0("Graphs/", category, "_plot.png"), plot = category_plot, width = 10, height = 8)
}
