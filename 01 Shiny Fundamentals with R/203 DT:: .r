### Add numericInput

# The app on the right allows users to randomly select a desired number of movies, 
# and displays some information on the selected movies in a tabular output.
# This table is created using a new function, renderDataTable function from the DT package, 
# but for now we will keep our focus on the numericInput widget. 
# We will also learn to define variables outside of the app so that they can be used in multiple spots to 
# make our code more efficient.


### Instructions

# Make sure elements in the sidebarPanel are separated by commas
# Calculate n_total (total number of movies in the dataset) as nrow(movies) before the UI definition.
# In the text instructions: Use n_total instead of the hard-coded "651".
# In the numericInput widget: 
# ....(1) Define min and max arguments to be 1 and n_total, respectively, 
# ....(2) Leave the values of inputId and label as they are. 
# ....(3) Change the default value of the sample size to 30. 
# ....(4) Set the step parameter such that values increase by 1 (instead of 10) when the up arrow is clicked in the UI.

### R Script

library(shiny)
library(dplyr)
library(DT)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))
n_total <- nrow(movies)

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Text instructions
      HTML(paste("Enter a value between 1 and", n_total)),
      
      # Numeric input for sample size
      numericInput(inputId = "n",
                   label = "Sample size:",min=1,max=n_total,
                   value = 30,
                   step = 1)
      
    ),
    
    # Output: Show data table
    mainPanel(
      DT::dataTableOutput(outputId = "moviestable")
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    movies_sample <- movies %>%
      sample_n(input$n) %>%
      select(title:studio)
    DT::datatable(data = movies_sample, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
