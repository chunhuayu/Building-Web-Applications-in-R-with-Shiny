### Stop with isolate()

# The isolate() function takes one argument, expr, which is an expression that can access reactive values or expressions. 
# And this function serves a very precise purpose: 
# it executes expr in a scope where reactive values or expression can be read, 
# but they do not trigger an output that depends on them to be re-evaluated. 
# However if that output depends on other reactives as well, when one of those changes, 
# the output is re-evaluated with the new value of the isolated expr.

# In this app we want to isolate the plot title, 
# such that the plot is updated with the new plot title only when other inputs to the plot change.

### Instructions

# Run the code and test out the functionality of the plot title input. 
# Is the plot title updated immediately after you're done typing the title?
# Modify the app using isolate() so that the plot title only gets updated when one of the other inputs is changed. 
# Note that it's best practice to place the argument of the isolate function in curly braces.

### R script
library(shiny)
library(ggplot2)
library(tools)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# UI
ui <- fluidPage(
  sidebarLayout(
    
    # Input
    sidebarPanel(
      
      # Enter text for plot title
      textInput(inputId = "plot_title", 
                label = "Plot title", 
                placeholder = "Enter text to be used as plot title"),
      
      # Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "audience_score"),
      
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "critics_score"),
      
      # Select variable for color
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("Title Type" = "title_type", 
                              "Genre" = "genre", 
                              "MPAA Rating" = "mpaa_rating", 
                              "Critics Rating" = "critics_rating", 
                              "Audience Rating" = "audience_rating"),
                  selected = "mpaa_rating"),
      
      # Set alpha level
      sliderInput(inputId = "alpha", 
                  label = "Alpha:", 
                  min = 0, max = 1, 
                  value = 0.5),
      
      # Set point size
      sliderInput(inputId = "size", 
                  label = "Size:", 
                  min = 0, max = 5, 
                  value = 2)
      
    ),
    
    # Output:
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

# Define server function required to create the scatterplot-
server <- function(input, output, session) {
  
  # Create scatterplot object the plotOutput function is expecting 
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y, color = input$z)) +
      geom_point(alpha = input$alpha, size = input$size) +
      labs( title = isolate({input$plot_title }))
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
