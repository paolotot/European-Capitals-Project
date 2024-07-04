# ui for European Capitals

library(shiny)
library(openxlsx)

data_model <- read.xlsx("EuropeanCapitalsDataUpsampled.xlsx")

pageWithSidebar(
  
  # Page header
  headerPanel("European Capitals Predictor"),
  
  # Input values
  sidebarPanel(
    HTML("<h3>Input parameters</h4>"),
    sliderInput("Cost",
                label = "Cost of Living",
                value = 5.0,
                min=1, max=5),
    sliderInput("Transport",
                label = "Means of Transportation",
                value = 5.0,
                min=1, max=5),
    sliderInput("Arthist",
                label = "Art and History",
                value = 5.0,
                min=1, max=5),
    sliderInput("Landscapes",
                label = "Landscapes",
                value = 5.0,
                min=1, max=5),
    sliderInput("Outdoor",
                label = "Outdoor Activities",
                value = 5.0,
                min=1, max=5),
    sliderInput("Food",
                label = "Local Food",
                value = 5.0,
                min=1, max=5),
    sliderInput("Culture",
                label = "Local Culture",
                value = 5.0,
                min=1, max=5),
    sliderInput("Night",
                label = "Night Life",
                value = 5.0,
                min=1, max=5),
    sliderInput("Language",
                label = "Language Barrier",
                value = 5.0,
                min=1, max=5),
    sliderInput("Interaction",
                label = "Interaction with Locals",
                value = 5.0,
                min=1, max=5),
    sliderInput("Safety",
                label = "Safety",
                value = 5.0,
                min=1, max=5),
    
    actionButton("submitbutton", "Submit", class = "btn btn-primary")
  ),
  
  mainPanel(
    tags$label(h3("Status/Output")), # Status/Output Text Box
    verbatimTextOutput("contents"),
    tableOutput("tabledata") # Prediction results table
    
  )
)
