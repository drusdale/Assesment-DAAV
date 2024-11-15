# Work From Home Environmental Factors Analysis

## Project Overview
This R script analyses how various environmental factors affect productivity and satisfaction when working from home. The analysis examines multiple factors including ventilation, lighting, presence of pets, family members, and work arrangements.

## Prerequisites

### Required R Packages
- tidyverse (for data manipulation and visualization)
- dplyr (for data transformation)
- ggplot2 (for creating plots)

Install the required packages using:
```R
install.packages("tidyverse")
install.packages("dplyr")
install.packages("ggplot2")
```

### Data Requirements
The script expects an RData file (`OSF_WFH.RData`) in the [RawData directory](https://github.com/drusdale/Assesment-DAAV/tree/main/RawData) containing the following variables:
- Single-item Scale Productivity Home
- Single-item Scale Work Satisfaction Home
- Ventilation Cat
- Home Office Light
- Where Work?
- Children Home during Office Hours
- Partner Home during Office Hours
- Pet - Dog
- Pet - Cat
- geslacht

Note: `geslacht` translates to `gender`

## Project Structure
```
├── Assesment-DAAV.Rproj
├── RawData/
│   └── OSF_WFH.RData
├── Graphs/
│   ├── overall_plot.png
│   └── [category]_plot.png
├── analysis_script.R
├── LICENSE
└── README.md
```

## Data Processing
The script performs the following data transformations:
1. Removes rows with missing values
2. Creates binary indicators for each environmental factor
3. Calculates mean productivity and satisfaction scores for each factor
4. Transforms data for visualization purposes

## Generated Variables
The script creates binary (0/1) indicators for:
- Ventilation levels (High, Medium, Low)
- Home office lighting (Natural, Average, No Natural)
- Pet presence (Dog, Cat)
- Partner presence during office hours
- Children presence during office hours
- Work from home status (Partial, Exclusive)
- Gender (Male, Female)

## Visualizations
The script generates two types of plots:

### Overall Plot
- Comprehensive visualization showing all environmental factors
- Displays both productivity and satisfaction metrics
- Saved as `overall_plot.png`

### Category-Specific Plots
- Individual plots for each category of factors
- Allows detailed examination of specific environmental aspects
- Saved as separate PNG files in the Graphs directory

## Output
All visualizations are saved in the `Graphs` directory with the following specifications:
- Format: PNG
- Dimensions: 10 x 8 inches
- White background
- Flipped coordinates for better readability
- Color scheme: Pink (Productivity) and White (Satisfaction)

## Scale Information
- Both productivity and satisfaction are measured on a scale from 0 to 10
- All visualizations maintain consistent scaling for comparison purposes

## Usage
1. Ensure all required packages are installed
2. (Optional if the file already exists) Download [OSF_WFH.RData](https://osf.io/download/df7mz/) this can be done by clicking the file or going to the project on [OSF Registries](https://osf.io/h6j3f)
2. Place the `OSF_WFH.RData` file in the `RawData` directory
3. Run the script in R or RStudio
4. Check the `Graphs` directory for generated visualizations

## Data Interpretation
- Bar lengths represent mean values for each factor
- Higher values indicate better productivity/satisfaction
- Each factor is shown with both productivity and satisfaction measures for easy comparison
- Factors are grouped logically for easier interpretation

## Notes
- The script automatically creates the `Graphs` directory if it doesn't exist
- Missing values are removed to ensure data quality
- All calculations use NA-safe functions to handle any remaining missing values

## Contributing
To contribute to this analysis:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request with a clear description of changes

## License
CC-By Attribution-NonCommercial-NoDerivatives 4.0 International

## References

1. Stroom M, Kok N. Does working from home work? That depends on the home! [Internet]. OSF; 2023. Available from: [osf.io/h6j3f](https://osf.io/h6j3f).