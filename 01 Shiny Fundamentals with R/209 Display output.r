### Displaying text outputs

# This exercise will introduce you to two types of text outputs in Shiny: textOutput and verbatimTextOutput. 
# We will use these in an app where the user selects two variables and their relationship is visualized with a scatterplot, 
# averages of both variables are displayed with textOutput, 
# and the output of a linear regression is displayed with verbatimTextOutput. 
# The sample code on the right only does some of these things.


### Instructions

# Check out the help for the textOutput and verbatimTextOutput functions to try to predict 
#...what the difference in the displayed results will be.

# In the UI: Add the appropriate output functions to display the averages and the regression output.
# Check the server function to find the ouput IDs, and add commas as needed.


### R Script

library(shiny)
library(dplyr)
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
    
    # Output(s)
    mainPanel(
      plotOutput(outputId = "scatterplot"),
      textOutput(outputId = "avg_x"), # avg of x
      textOutput(outputId = "avg_y"), # avg of y
      verbatimTextOutput(outputId = "lmoutput") # regression output
    )
  )
)

# Server
server <- function(input, output) {
  
  # Create scatterplot
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
      geom_point()
  })
  
  # Calculate average of x
  output$avg_x <- renderText({
    avg_x <- movies %>% pull(input$x) %>% mean() %>% round(2)
    paste("Average", input$x, "=", avg_x)
  })
  
  # Calculate average of y
  output$avg_y <- renderText({
    avg_y <- movies %>% pull(input$y) %>% mean() %>% round(2)
    paste("Average", input$y, "=", avg_y)
  })
  
  # Create regression output
  output$lmoutput <- renderPrint({
    x <- movies %>% pull(input$x)
    y <- movies %>% pull(input$y)
    summ <- summary(lm(y ~ x, data = movies)) 
    print(summ, digits = 3, signif.stars = FALSE)
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
