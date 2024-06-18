# Load all Libraries
library(shiny)
library(ggplot2)
library(readxl)
library(dplyr)
library(tidyverse)
library(ggsci)

# Variables provided in the .xlsx file.
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
  titlePanel("CTD Data Plotter"),
  
  # Variable selection
  tags$div(
    style = "display: flex; flex-direction: row;",
    textInput("path", "Select Folder:", NULL, placeholder = "Absolute path of the folder"),
    selectInput(
      "fileSelect",
      "Select file:",
      choices = NULL,
      multiple = TRUE
    )
  ),
  
  shiny::checkboxGroupInput(
    "varSelect",
    "Select variables:",
    choices = var,
    inline = TRUE,
    selected = "FlSP"
  ),
  
  # Dynamic range inputs
  uiOutput("rangeInputs"),
  
  tags$div(
    style = "display: flex; flex-direction: row;",
    shiny::checkboxInput("lineToggle", "Show Line", value = FALSE),
    shiny::checkboxInput("showSmooth", "Show Average", value = TRUE),
    shiny::checkboxInput("showse", "Show Standard Error", value = TRUE)
  ),
  
  # Added plotOutput for rendering the plot
  plotOutput("plot", width = "auto", height = 1000),
  
  # File saving Parameters
  tags$div(
    style = "display: flex; flex-direction: column;",
    tags$div(
      style = "display: flex; flex-direction: row;",
      textInput("dpi", "Select dpi:", 300, placeholder = "300"),
      textInput("pwidth", "Select Width:", 7, placeholder = "7"),
      textInput("pheight", "Select Height:", 14, placeholder = "14")
    ),
    tags$div(
      style = "display: flex; flex-direction: row;",
      textInput("dstpath", "Select Destination Folder:", "~/Pictures", placeholder = "~/Pictures"),
      textInput("dstplot", "Select File name:", "plot", placeholder = "plot"),
      actionButton("savePlot", "Save Plot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # Observe path input and update file selection
  observe({
    req(input$path)
    data_folder <- input$path
    if (dir.exists(data_folder)) {
      xlsx_files <- list.files(path = data_folder, pattern = "\\.xlsx$", full.names = TRUE)
      file_names <- tools::file_path_sans_ext(basename(xlsx_files))
      updateSelectInput(session, "fileSelect", choices = file_names)
    } else {
      updateSelectInput(session, "fileSelect", choices = NULL)
    }
  })
  
  # Reactive data for selected files and variables
  combined_data <- reactive({
    req(input$fileSelect, input$varSelect)
    bind_rows(lapply(input$fileSelect, function(file) {
      path <- file.path(input$path, paste0(file, ".xlsx"))
      read_excel(path) %>%
        drop_na() %>%
        mutate(File = file)
    }))
  })
  
  # Dynamic range inputs based on selected variables
  output$rangeInputs <- renderUI({
    req(combined_data())
    data <- combined_data()
    
    lapply(input$varSelect, function(var) {
      min_val <- min(data[[var]], na.rm = TRUE)
      max_val <- max(data[[var]], na.rm = TRUE)
      sliderInput(
        inputId = paste0("range_", var),
        label = paste("Range for", var),
        min = min_val,
        max = max_val,
        value = c(min_val, max_val)
      )
    })
  })
  
  # Reactive plot generation
  plot <- reactive({
    req(input$fileSelect, input$varSelect)
    
    data <- combined_data()
    
    long_data <- data %>%
      pivot_longer(cols = input$varSelect, names_to = "Variable", values_to = "Value") %>%
      mutate(FileVariable = paste(File, Variable, sep = " - "))
    
    # Filter data based on user-defined ranges
    for (var in input$varSelect) {
      range <- input[[paste0("range_", var)]]
      long_data <- long_data %>%
        filter(Variable != var | (Value >= range[1] & Value <= range[2]))
    }
    
    plot <- ggplot(long_data, aes(x = DepSM, y = Value, color = FileVariable)) +
      coord_flip() +
      scale_x_reverse() +
      facet_wrap(~ Variable, scales = "free") +
      xlab("Depth(m)") +
      theme_minimal() +
      scale_color_uchicago() +
      theme(legend.title = element_blank(), legend.position = "bottom")
    
    if (input$lineToggle) {
      plot <- plot + geom_line()
    }
    if (input$showSmooth) {
      plot <- plot + geom_smooth(se = input$showse, method = "gam")
    }
    
    plot
  })
  
  # Render the plot
  output$plot <- renderPlot({
    plot()
  })
  
  # Save plot to file
  observeEvent(input$savePlot, {
    ggsave(
      filename = file.path(input$dstpath, paste0(input$dstplot, ".png")),
      plot = plot(),
      width = as.integer(input$pwidth),
      height = as.integer(input$pheight),
      units = "in",
      dpi = as.integer(input$dpi)
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
