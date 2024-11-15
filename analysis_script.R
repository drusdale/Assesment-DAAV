# Load required libraries for data manipulation and visualization
install.packages("tidyverse")
install.packages("dplyr")
install.packages("ggplot2")

library(tidyverse)  # Collection of data science packages
library(dplyr)      # Data manipulation functions
library(ggplot2)    # Creating visualizations

# Import the Work From Home dataset from RData file
load("RawData/OSF_WFH.RData")
df = OSF_WFH

# Remove any rows with missing values to ensure data quality
nna_df = df %>% drop_na()

# Display sample data for initial inspection
head(nna_df)

# Define relevant variables for analysis
# Including productivity, satisfaction, and various environmental factors
columns_to_keep <- c("Single-item Scale Productivity Home", "Single-item Scale Work Satisfaction Home",
                     "Ventilation Cat", "Home Office Light", "Where Work?", "Childern Home during Office Hours", "Partner Home during Office Hours",
                     "Pet - Dog", "Pet - Cat", "geslacht")

# Define output variables after data transformation
# These will be binary (0/1) indicators for each category
columns_to_keep_after_mutation <- c("Productivity", "Satisfaction", "High Ventilation", "Medium Ventilation", "Low Ventilation",
                                    "Natural Home Office Light", "Average Home Office Light", "No Natural Home Office Light",
                                    "Dog at home", "No Dog at home", "Cat at home", "No Cat at home", "Partner Always Home", "Partner Sometimes Home",
                                    "Partner Never Home", "No Partner", "Children Always Home", "Children Sometimes Home",
                                    "Children Never Home", "No Children", "WFH Partically", "WFH Exclusively", "Female", "Male")

# Data transformation pipeline
nna_df <- nna_df %>%
  # Select only the columns we need
  select(all_of(columns_to_keep)) %>%
  # Rename main outcome variables for clarity
  rename(
    Productivity = "Single-item Scale Productivity Home",
    Satisfaction = "Single-item Scale Work Satisfaction Home",
  ) %>%
  # Create binary indicators for each category
  mutate(
    # Gender indicators
    Male = case_when(
      geslacht == "Male" ~ 1,
      TRUE ~ 0
    ),
    Female = case_when(
      geslacht == "Female" ~ 1,
      TRUE ~ 0
    ),
    # Ventilation quality indicators
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
    # Lighting condition indicators
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
    # Pet ownership indicators
    `Dog at home` = case_when(
      `Pet - Dog` == "Yes" ~ 1,
      TRUE ~ 0
    ),
    `No Dog at home` = case_when(
      `Pet - Dog` == "No" ~ 1,
      TRUE ~ 0
    ),
    `Cat at home` = case_when(
      `Pet - Cat` == "Yes" ~ 1,
      TRUE ~ 0
    ),
    `No Cat at home` = case_when(
      `Pet - Cat` == "No" ~ 1,
      TRUE ~ 0
    ),
    # Gender indicators (duplicate removed in final selection)
    `Male` = case_when(
      `geslacht` == 'Male' ~ 1,
      TRUE ~ 0
    ),
    `Female` = case_when(
      `geslacht` == 'Female' ~ 1,
      TRUE ~ 0
    ),
    # Partner presence indicators
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
    # Children presence indicators
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
    # Work from home status indicators
    `WFH Partically` = case_when(
      `Where Work?` == 'Partially Work' ~ 1,
      TRUE ~ 0
    ),
    `WFH Exclusively` = case_when(
      `Where Work?` == 'Exclusively Home' ~ 1,
      TRUE ~ 0
    )
  ) %>%
  # Keep only the transformed columns
  select(all_of(columns_to_keep_after_mutation))

# Prepare data for visualization
# Calculate mean productivity and satisfaction for each factor
cols <- columns_to_keep_after_mutation[3:length(columns_to_keep_after_mutation)]
bar_data <- data.frame()

# Loop through each factor and calculate metrics
for (col in cols) {
  temp <- nna_df %>%
    group_by(!!sym(col)) %>%
    summarise(
      Satisfaction = mean(Satisfaction, na.rm = TRUE),
      Productivity = mean(Productivity, na.rm = TRUE)
    ) %>%
    # Reshape data for plotting
    pivot_longer(cols = c(Satisfaction, Productivity), names_to = "Metric", values_to = "Value") %>%
    mutate(Variable = col) %>%
    # Keep only rows where the factor is present (value = 1)
    filter(!!sym(col) != 0)
  
  bar_data <- bind_rows(bar_data, temp)
}

# Define the order of variables for consistent visualization
variable_order <- c("High Ventilation", "Medium Ventilation", "Low Ventilation",
                    "Natural Home Office Light", "Average Home Office Light", "No Natural Home Office Light",
                    "Dog at home", "No Dog at home", "Cat at home", "No Cat at home", "Partner Always Home", "Partner Sometimes Home",
                    "Partner Never Home", "No Partner", "Children Always Home", "Children Sometimes Home",
                    "Children Never Home", "No Children", "WFH Partically", "WFH Exclusively", "Female","Male")

# Convert Variable to factor with specified order
bar_data$Variable <- factor(bar_data$Variable, levels = variable_order)

# Create main visualization
overall_plot <- ggplot(bar_data, aes(x = Variable, y = Value, fill = Metric)) +
  geom_bar(stat = "identity", position = position_dodge2(preserve = "single"), size = 0.5, color = "black") +
  scale_fill_manual(values = c("Productivity" = "pink", "Satisfaction" = "white")) +
  labs(title = "How do environmental factors affect Productivity and Satisfaction when working from home", 
       x = "Variable", y = "Value") +
  theme_minimal(base_size = 15) +
  theme(
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA),
    legend.background = element_rect(fill = "white", color = NA),
    legend.key = element_rect(fill = "white", color = NA),
    axis.text.y = element_text(size = 10),
    # Center align the title and adjust its appearance
    plot.title = element_text(
      hjust = 0.5,  # Centers the title horizontally
      size = 13,    # Adjust size as needed
      face = "bold", # Makes title bold
      margin = margin(b = 20) # Adds some space below the title
    )
  ) +
  coord_flip() +
  scale_y_continuous(limits = c(0, 10), breaks = 0:40)

# Display the plot
print(overall_plot)

# Create output directory and save main plot
dir.create("Graphs", showWarnings = FALSE)
ggsave("Graphs/overall_plot.png", plot = overall_plot, width = 10, height = 8)

# Generate and save individual category plots
for (category in names(categories)) {
  # Filter data for current category
  category_vars <- categories[[category]]
  category_data <- bar_data %>% filter(Variable %in% category_vars)
  
  # Create category-specific plot
  category_plot <- ggplot(category_data, aes(x = Variable, y = Value, fill = Metric)) +
    geom_bar(stat = "identity", position = position_dodge2(preserve = "single"), size = 0.5, color = "black") +
    scale_fill_manual(values = c("Productivity" = "pink", "Satisfaction" = "white")) +
    labs(title = category_titles[[category]], x = "Variable", y = "Value") +
    theme_minimal(base_size = 15) +
    theme(
      panel.background = element_rect(fill = "white", color = NA),
      plot.background = element_rect(fill = "white", color = NA),
      legend.background = element_rect(fill = "white", color = NA),
      legend.key = element_rect(fill = "white", color = NA),
      axis.text.y = element_text(size = 10),
      # Center align the title and adjust its appearance
      plot.title = element_text(
        hjust = 0.5,  # Centers the title horizontally
        size = 16,    # Adjust size as needed
        face = "bold", # Makes title bold
        margin = margin(b = 20) # Adds some space below the title
      )
    ) +
    coord_flip() +
    scale_y_continuous(limits = c(0, 10), breaks = 0:40)
  
  # Save category plot
  ggsave(paste0("Graphs/", category, "_plot.png"), plot = category_plot, width = 10, height = 8)
}