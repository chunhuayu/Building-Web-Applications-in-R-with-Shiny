### req, a.k.a. your best friend

# The app on the right is the one you developed in the previous exercise. Run the code using the "Run Code" button. 
# Then, in the Shiny app (not in the code), delete the numeric value (30) in the sample size box. 
# You will encounter an error: Error: size is not a numeric or integer vector.

# In order to avoid such errors, which users of your app could very easily encounter, 
# we need to hold back the output from being calculated if the input is missing. 
# The req function is the simplest and best way to do this, 
# it ensures that values are available ("truthy") before proceeding with a calculation or action. 
# If any of the given values is not truthy, 
# the operation is stopped by raising a "silent" exception (neither logged by Shiny, nor displayed in the Shiny app's UI).

### Instructions
# In the server: Inside the renderDataTable function, add req(input$n) before movies_sample is calculated.
# Run your app again and once again in the Shiny app (not in the code) delete the numeric value (30) in the sample size box 
# to confirm that Error: size is not a numeric or integer vector. Also confirm that when no sample size is given, 
# the output table doesn't appear in the app either.

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
                   label = "Sample size:",
                  value =30,
                   min = 1, max = n_total,
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
req(input$n)
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
