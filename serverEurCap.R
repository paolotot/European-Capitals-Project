# Server file for European Capitals

library(shiny)
library(data.table)
library(randomForest)
library(openxlsx)

# Read in the RF model
model <- readRDS("model_eucap.rds")

shinyServer(function(input, output, session){
  
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
  
})
