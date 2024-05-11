# CTD-data-plotter

This is a Data plotter for CTD data for each Excel File.

The .xlsx files should be placed in the data/ folder.
There should only be one sheet per file.
(`CSV support coming soon`)

Each file should have the following variables.

-   **DepSM**: Depth in Meters.
-   **Sal00**: Salinity.
-   **Tv290C**: Temperature is Celsius.
-   **FlSP**: Flouresence.
-   **SeaTurbMtr**: Sea terbidity in Meters.
-   **Par**: Photosynthetic active radiation.
-   **Sbeox0Mm/L**: Desolved Oxygen per liter.
-   **AltM**
-   **Sbeox0PS**

# Use

Clone the repo to your machine and open it as a project in R studio.
Add all your .xlsx files to the data folder.
(`Dynamcic folder selection` coming soon) Run the `CTD_dataplotter.Rmd` file to use the application.
Select desired files and variables.
Select raw data line or Averaged line with or without standard error.
The averaged line used geom_smooth with "gam" method.
