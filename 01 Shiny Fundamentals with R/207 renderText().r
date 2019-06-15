### renderText
# In this app the user selects x and y variables for the scatterplot. 
# We will extend the app to also include a textOutput which prints the correlation between the two selected variables 
# as well as some informational text.

### Instructions

# On line 43, create the text to be printed using the paste0() function: 
# ...."Correlation = ____. 
# Note: If the relationship between the two variables is not linear, the correlation coefficient will not be meaningful."

# First use the cor() function to calculate the correlation. Use cor(movies[, input$x], movies[, input$y], use = "pairwise").
# Round it to three decimal places with the round() function, and save the result as r.

# Use the paste0() function to construct the text output.
# Place the text within the renderText function, and assign to output$correlation.

### R Script

library(shiny)
library(ggplot2)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# UI
ui <- fluidPage(
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                  selected = "audience_score"),
      
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                  selected = "critics_score")
    ),
    
    # Outputs
    mainPanel(
      plotOutput(outputId = "scatterplot"),
      textOutput(outputId = "correlation")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
      geom_point()
  })
  
  # Create text output stating the correlation between the two ploted 
  output$correlation <- renderText({

    r <- round(cor(movies[,input$x],movies[,input$y],use="pairwise"), 3)
    paste0("Correlation = ", r, ". Note: If the relationship between the two variables is not linear, the correlation coefficient will not be meaningful.")
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
