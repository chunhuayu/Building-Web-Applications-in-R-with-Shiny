### Add reactive data frame

# We ended the previous chapter with an app that allows you to download a data file with selected variables from the movies dataset. We will now extend this app by adding a table output of the selected data as well. Given that the same dataset will be used in two outputs, it makes sense to make our code more efficient by using a reactive data frame.

### Instructions
# With the function reactive(), define movies_selected: 
# a reactive expression that is a data frame with the selected variables (input$selected_var).
# Use the newly constructed movies_selected() reactive data frame (instead of movies) in the remainder of the app when 
# defining output$moviestable and output$download_data.

### R Script
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
      HTML("Select filetype and variables, then download and/or view the data."),
      br(), br(),
      downloadButton(outputId = "download_data", label = "Download data"),
      br(), br(),
      DT::dataTableOutput(outputId = "moviestable")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Create reactive data frame
  movies_selected <- reactive({
    req(input$selected_var)               # ensure input$selected_var is available
    movies %>% select(input$selected_var) # select columns of movies
  })
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    DT::datatable(data = movies_selected(), 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
  # Download file
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("movies.", input$filetype)
    },
    content = function(file) { 
      if(input$filetype == "csv"){ 
        write_csv(movies_selected(), path = file) 
      }
      if(input$filetype == "tsv"){ 
        write_tsv(movies_selected(), path = file) 
      }
    }
  )
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
