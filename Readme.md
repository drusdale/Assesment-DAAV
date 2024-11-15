# Work From Home Environmental Factors Analysis

## Project Overview

This project analyses how various environmental factors affect
productivity and satisfaction when working from home. The analysis
examines multiple factors including ventilation, lighting, presence of
pets, family members, and work arrangements. The analysis is performed
using R and the results are visualised through various plots.

## Prerequisites

### Required R Packages

-   [tidyverse](https://cran.r-project.org/package=tidyverse) (for data
    manipulation and visualisation)
-   [dplyr](https://cran.r-project.org/package=dplyr) (for data
    transformation)
-   [ggplot2](https://cran.r-project.org/package=ggplot2) (for creating
    plots)
-   [farver](https://cran.r-project.org/package=farver) (for colour
    manipulation in ggplot2)
-   [scales](https://cran.r-project.org/package=scales) (often needed
    with ggplot2)
-   [lifecycle](https://cran.r-project.org/package=lifecycle) (for
    handling deprecated features)

Install the required packages by running the `Init.R` script to
initialise the environment and install the required packages using
Packrat.

1.  Open the `Init.R` script in R or RStudio
2.  Run the script to install the required packages

### Data Requirements

The script expects an RData file (`OSF_WFH.RData`) in the [RawData
directory](https://github.com/drusdale/Assesment-DAAV/tree/main/RawData)
containing the following variables:

-   Single-item Scale Productivity Home

-   Single-item Scale Work Satisfaction Home

-   Ventilation Cat

-   Home Office Light

-   Where Work?

-   Children Home during Office Hours

-   Partner Home during Office Hours

-   Pet - Dog

-   Pet - Cat

-   geslacht

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
├── Init.R
├── Setup.R
├── LICENSE
├── .Rprofile
├── .gitignore
└── README.md
```

## Data Processing

The script performs the following data transformations: 1. Removes rows
with missing values 2. Creates binary indicators for each environmental
factor 3. Calculates mean productivity and satisfaction scores for each
factor 4. Transforms data for visualisation purposes

## Generated Variables

The script creates binary (0/1) indicators for:

-   Ventilation levels (High, Medium, Low)

-   Home office lighting (Natural, Average, No Natural)

-   Pet presence (Dog, Cat)

-   Partner presence during office hours

-   Children presence during office hours

-   Work from home status (Partial, Exclusive)

-   Gender (Male, Female)

## Visualisations

The script generates two types of plots:

### Overall Plot

-   Comprehensive visualisation showing all environmental factors
-   Displays both productivity and satisfaction metrics
-   Saved as `overall_plot.png`

### Category-Specific Plots

-   Individual plots for each category of factors
-   Allows detailed examination of specific environmental aspects
-   Saved as separate PNG files in the Graphs directory

## Output

All visualisations are saved in the `Graphs` directory with the
following specifications: - Format: PNG - Dimensions: 10 x 8 inches -
White background - Flipped coordinates for better readability - Colour
scheme: Pink (Productivity) and White (Satisfaction)

## Scale Information

-   Both productivity and satisfaction are measured on a scale from 0 to
    10
-   All visualisations maintain consistent scaling for comparison
    purposes

## Usage

1.  Ensure all required packages are installed
2.  Run the `Init.R` script to initialise the environment
3.  Run the `analysis_script.R` script in R or RStudio
4.  Check the `Graphs` directory for generated visualisations

## Data Interpretation

-   Bar lengths represent mean values for each factor
-   Higher values indicate better productivity/satisfaction
-   Each factor is shown with both productivity and satisfaction
    measures for easy comparison
-   Factors are grouped logically for easier interpretation

## Notes

-   The script automatically creates the `Graphs` directory if it
    doesn't exist
-   Missing values are removed to ensure data quality
-   All calculations use NA-safe functions to handle any remaining
    missing values

## Contributing

To contribute to this analysis:

1\. Fork the repository

2\. Create a feature branch

3\. Submit a pull request with a clear description of changes

## License

CC-By Attribution-NonCommercial-NoDerivatives 4.0 International

## References

1.  Stroom M, Kok N. Does working from home work? That depends on the
    home! [Internet]. OSF; 2023. Available from:
    [osf.io/h6j3f](https://osf.io/h6j3f). \# Work From Home
    Environmental Factors Analysis
