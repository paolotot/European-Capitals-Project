
library(shiny)
library(data.table)
library(randomForest)
library(openxlsx)


model <- readRDS("model_eucap.rds")

data_model <- read.xlsx("https://github.com/paolotot/European-Capitals-Project/raw/main/EuropeanCapitalsDataUpsampled.xlsx")


# Define UI for application that draws a histogram

ui <- pageWithSidebar(
  
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



# Server component

server <- function(input, output, session){
  
  # Input Data
  datasetInput <- reactive({
    
    df <- data.frame(
      Name = c("Cost",
               "Transport",
               "Arthist",
               "Landscapes",
               "Outdoor",
               "Food",
               "Culture",
               "Night",
               "Language",
               "Interaction",
               "Safety"),
      Value = as.character(c(input$Cost,
                             input$Transport,
                             input$Arthist,
                             input$Landscapes,
                             input$Outdoor,
                             input$Food,
                             input$Culture,
                             input$Night,
                             input$Language,
                             input$Interaction,
                             input$Safety)),
      stringsAsFactors = FALSE)
    
    Capital <- 0
    df <- rbind(df, Capital)
    input <- transpose(df)
    write.table(input, "input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
    test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
    
    predictions <- round(predict(model, test, type="prob"), 5)
    capital_names <- colnames(predictions) # Assuming the column names are the capital names
    
    Output <- data.frame(Capital = capital_names, Prediction = as.numeric(predictions))
    
    # Sort the output by prediction scores in decreasing order
    Output <- Output[order(-Output$Prediction), ]
    print(Output)
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if(input$submitbutton > 0){
      isolate("Calculation complete.")
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if(input$submitbutton > 0){
      isolate(datasetInput())
    }
  })
  
}


# Create the shiny app
shinyApp(ui = ui, server = server)
