#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2)
library(readxl)
library(dplyr)
library(tidyverse)
library(ggsci)

var <- c(
  "Sal00",
  "Tv290C",
  "FlSP",
  "SeaTurbMtr",
  "Par",
  "Sbeox0Mm/L",
  "Sbeox0PS",
  "AltM",
  "Flag"
)

# Define UI for application that draws a histogram
ui <- fluidPage(
  # Application title
  titlePanel("CTD Data Plotter"),
  tags$div(
    style = "display: flex; flex-direction: row;",
  textInput("path", "Select Folder:", NULL, placeholder = "Absolute path of the folder"),
  selectInput(
    "fileSelect",
    "Select file:",
    choices = NULL,
    multiple = TRUE
  )),
  shiny::checkboxGroupInput(
    "varSelect",
    "Select variables:",
    choices = var,
    inline = TRUE,
    selected = "FlSP"
  ),
  tags$div(
    style = "display: flex; flex-direction: row;",
    shiny::checkboxInput("lineToggle", "Show Line", value = FALSE),
    shiny::checkboxInput("showSmooth", "Show Average", value = TRUE),
    # Corrected a typo here
    shiny::checkboxInput("showse", "Show Standard Error", value = TRUE),
    actionButton("savePlot", "Save Plot")
  ),
  plotOutput("plot") # Added plotOutput for rendering the plot
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  # Added session argument
  
  observe({
    if (!is.null(input$path)) {
      data_folder <- input$path
      xlsx_files <- list.files(path = data_folder,
                               pattern = "\\.xlsx$",
                               full.names = TRUE)
      file_names <- tools::file_path_sans_ext(basename(xlsx_files))
      updateSelectInput(session, "fileSelect", choices = file_names)
    }
  })
  
  # Render plot
  plot <- shiny::reactive({
    # Ensure selections are made
    req(input$fileSelect, input$varSelect)
    
    # Read and combine data from selected files, adding a "File" column
    combined_data <- bind_rows(lapply(input$fileSelect, function(file) {
      path <- file.path(input$path, paste0(file, ".xlsx"))
      read_excel(path) %>%
        drop_na() %>% # removes NA row if any
        mutate(File = file)  # Add a column for the source file
    }))
    
    # Reshape data to long format for multi-variable plotting
    long_data <- combined_data %>%
      pivot_longer(
        cols = input$varSelect,
        names_to = "Variable",
        values_to = "Value"
      )
    
    # Create a unique identifier for color grouping using both File and Variable
    long_data <- long_data %>%
      mutate(FileVariable = paste(File, Variable, sep = " - "))
    
    # Create the plot with ggplot, using `FileVariable` for color grouping
    plot <-  ggplot(long_data, aes(x = DepSM, y = Value, color = FileVariable)) +
      coord_flip() + # Rotate the plot to have X axis Vertical
      scale_x_reverse() + # Reverse the x axis to have 0 at top
      facet_wrap(~ Variable, scales = "free") + # Each Variable gets its own plot
      # ggtitle("Multi-File Variable Plot") + # Title for the Plot
      xlab("Depth(m)") + # X axis Label
      theme_minimal() + # Theme of plot
      scale_color_uchicago() + # Color Palette
      theme(legend.title = element_blank(), legend.position = "bottom") # Legend
    
    # Conditional rendering of geom_line and geom_smooth based on checkbox
    if (input$lineToggle) {
      plot <- plot + geom_line() # Add geom_line if checkbox is checked
    }
    if (input$showSmooth) {
      plot <- plot + geom_smooth(se = input$showse, method = "gam") # Add geom_smooth if checkbox is checked
    }
    
    return(plot)
  })
  
  output$plot <- renderPlot({
    plot() # Render the plot
  })
  
  observeEvent(input$savePlot, {
    ggsave(
      paste0(input$path, "/plot.png"),
      plot(),
      width = 7,
      height = 14,
      units = "in",
      dpi = 300
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
