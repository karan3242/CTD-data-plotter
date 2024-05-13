# CTD-data-plotter

This is a Data plotter for CTD data for each Excel File.

There should only be one sheet per .xlsx file. (`CSV support coming soon`)

# Requierments

## Software tools

Latest Version of [R](https://www.r-project.org) and [shiny](https://shiny.posit.co), and a Browser.

In your R session run the following code to download shiny.

``` r
install.packages("shiny")
```

## Variables
Each file should have the following variables.

-   **DepSM**: Depth in Meters.
-   **Sal00**: Salinity.
-   **Tv290C**: Temperature is Celsius.
-   **FlSP**: Florescence.
-   **SeaTurbMtr**: Sea turbidity in Meters.
-   **Par**: Photosynthetic active radiation.
-   **Sbeox0Mm/L**: Dissolved Oxygen per liter.
-   **AltM**
-   **Sbeox0PS**

# Install

In your shell terminal clone the repo to your machine and open it as a project in R studio.

```
git clone https://github.com/karan3242/CTD-data-plotter.git
```

# Run using Shell

Navigate to the cloned folder and run the script.

```
Rscript CTD-data-plotter/ctd_plotter.R
```

Click on the `Listening on` link or past it in your browser's url bar to open the app.

# Run using RStudio

Open Rstudio and run `ctd_plotter.R`

# Use

- Add the path to your desired folder.
- Select desired files and variables.
- Select raw data line or Averaged line with or without standard error.
- Select image parameters.
- Provide the destination folder and file name
- Save the plot.


> The averaged line used geom_smooth with "gam" method.

> Plots will be saved as `.png`.
