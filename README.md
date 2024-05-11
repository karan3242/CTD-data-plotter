# CTD-data-plotter

This is a Data plotter for CTD data for each Excel File.

There should only be one sheet per .xlsx file.
(`CSV support coming soon`)

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

# Use

- Clone the repo to your machine and open it as a project in R studio.
- Run the `CTD_dataplotter.Rmd` file to use the application.
- Add the path to your desired folder.
- Select desired files and variables.
- Select raw data line or Averaged line with or without standard error.
- Save the plot.

> The averaged line used geom_smooth with "gam" method.

> Plots will be saved to the folder provided in the data folder.