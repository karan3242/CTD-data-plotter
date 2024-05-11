# CTD-data-plotter

This is a Data plotter for CTD data for each Excle File.

The .xlsx files should be placed in the data/ folder.
There should only be one sheet per file. (`CSV support coming soon`)

Each file should have the following variables.

- **DepSM**: Depth in Meters.
- **Sal00**: Salinity.
- **Tv290C**: Temprature is Celsius.
- **FlSP**: Glouresence.
- **SeaTurbMtr**: Seaterbidity in Meters.
- **Par**: Photosyentheticaly activy raditation.
- **Sbeox0Mm/L**: Desoved Oxygen per liter.
- **AltM**
- **Sbeox0PS**

# Use

Clone the repo to your machie and open it as a project in R stuio.
Add all your .xlsx files to the data folder. (`Dynamcic folder selection` coming soon)
Run the `CTD_dataplotter.Rmd` file to use the application.
Select desired files and varables.
Select raw data line or Avraged line.
The avraged line used geom_smooth with "gam" method.
Standard error lines are turned off. (Option to turn them on coming soon.)
