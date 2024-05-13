# CTD-data-plotter

This is a Data plotter for CTD data for each Excel File.

There should only be one sheet per .xlsx file. (`CSV support coming soon`)

# Requierments

Latest Version of **R** and **Shiny**

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

``` sh
git clone https://github.com/karan3242/CTD-data-plotter.git
```

# Run using Shell

Navigate to the cloned folder and run the script.

``` sh
Rscript ctd_plotter.R
```

Click on the `Listening on` link.

# Run using RStudio

# Use

- Add the path to your desired folder.
- Select desired files and variables.
- Select raw data line or Averaged line with or without standard error.
- Select image parameters.
- Provide the destination folder and file name
- Save the plot.

> The averaged line used geom_smooth with "gam" method.

> Plots will be saved as `.png`.
