### Download data with downloadButton

# In this exercise you will develop an app that will allow you to download the data file in the format and with the 
# ...variables you specify. We introduce two new functions here: 
# ...downloadHandler() to be used in the server and downloadButton() to be used in the UI.

### Instructions

# In the UI: Add the function for displaying a button for downloading, and note the outputId to be referred to in the server.
# In the server:
# Add the outputId you noted in the previous step.
# Add the appropriate function for content from the Shiny application to be made available to the user as a file download.
# In the filename argument, complete the filename with the user's selection between csv and tsv.
# In the content argument, complete the conditions for the if statements for the user's selection for filetype.

library(shiny)
library(dplyr)
library(readr)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# UI
ui <- fluidPage(
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      
      # Select filetype
      radioButtons(inputId = "filetype",
                   label = "Select filetype:",
                   choices = c("csv", "tsv"),
                   selected = "csv"),
      
      # Select variables to download
      checkboxGroupInput(inputId = "selected_var",
                  label = "Select variables:",
                  choices = names(movies),
                  selected = c("title"))
      
    ),
    
    # Output(s)
    mainPanel(
      HTML("Select filetype and variables, then hit 'Download data'."),
      br(), br(), # line break and some visual separation
      downloadButton("download_data", "Download data")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Download file
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("movies.", input$filetype)
      },
    content = function(file) { 
      if(input$filetype == "csv"){ 
        write_csv(movies %>% select(input$selected_var), path = file) 
        }
      if(input$filetype == "tsv"){ 
        write_tsv(movies %>% select(input$selected_var), path = file) 
        }
    }
  )
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
