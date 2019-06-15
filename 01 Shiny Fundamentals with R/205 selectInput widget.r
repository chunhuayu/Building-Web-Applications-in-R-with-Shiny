### Select to selectize

# The app on the right can be used to display movies from selected studios. Currently you can only choose one studio, 
# but we'll modify it to allow for multiple selections. Additionally, there are 211 unique studios represented in this dataset, 
# we need a better way to select than to scroll through such a long list, and we address that with the selectize option, 
# which will suggest names of studios as you type them.


### Instructions

# View the help function for the selectInput widget by typing ?selectInput in the console, 
# and figure out how to enable the selectize and multiple selection options (or whether they are enabled by default).
# In the UI: Based on your findings add the necessary arguments to the selectInput widget.
# In the server: Add a call to the req function, just like you did in the previous exercise,
# but this time requiring that input$studio be available. 
# Update filter() to use the logical operator %in% (instead of ==) so that it works when multiple studios are selected.
# Run the app and 
# (1) confirm that you can select multiple studios, 
# (2) start typing "Warner Bros" to confirm selectize works, and 
# (3) delete all selections to confirm req is preventing an error from being displayed when no studio input is provided.

### R Script

library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))
all_studios <- sort(unique(movies$studio))

# UI
ui <- fluidPage(
    sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      selectInput(inputId = "studio",
                  label = "Select studio:",multiple = TRUE,
                  choices = all_studios,
                  selected = "20th Century Fox")
      
    ),
    
    # Output(s)
    mainPanel(
      DT::dataTableOutput(outputId = "moviestable")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
  req(input$studio)
    movies_from_selected_studios <- movies %>%
      filter(studio %in% input$studio) %>%
      select(title:studio)
    DT::datatable(data = movies_from_selected_studios, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
