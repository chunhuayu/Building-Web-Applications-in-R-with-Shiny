# The potential variables the user can select for the x and y axes and color 
# currently appear in the UI of the app the same way that they are spelled in the data frame header. 
# However we might want to label them in a way that is more human readable. 
# We can achieve this using named vectors for the choices argument, 
# in the format of "Human readable label" = "variable_name". As you're going through this exercise, watch out for typos!

### Instructions

# Fill in the blanks starting at line 17 with human readable labels for x and y inputs.
# Use the labels "IMDB rating", "IMDB number of votes", "Critics score", "Audience score", and "Runtime".
# Re-create the selectInput widget for color, z, 
# with options "title_type", "genre", "mpaa_rating", "critics_rating", and "audience_rating". 
# Use the same input ID "z" and the label "Color by:"
# Use the human readable labels "Title type", "Genre", "MPAA rating", "Critics rating", and "Audience rating".
# Make the default selection "mpaa_rating" just like in the previous exercise.



> library(shiny)
> library(ggplot2)
> load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))
> 
> # Define UI for application that plots features of movies
> ui <- fluidPage(
    
    # Sidebar layout with a input and output definitions
    sidebarLayout(
      
      # Inputs
      sidebarPanel(
        
        # Select variable for y-axis
        selectInput(inputId = "y", 
                    label = "Y-axis:",
                    choices = c("IMDB rating"          = "imdb_rating", 
                                "IMDB number of votes" = "imdb_num_votes", 
                                "Critics score"        = "critics_score", 
                                "Audience score"       = "audience_score", 
                                "Runtime"              = "runtime"), 
                    selected = "audience_score"),
        
        # Select variable for x-axis
        selectInput(inputId = "x", 
                    label = "X-axis:",
                    choices = c("IMDB rating"          = "imdb_rating", 
                                "IMDB number of votes" = "imdb_num_votes", 
                                "Critics score"        = "critics_score", 
                                "Audience score"       = "audience_score", 
                                "Runtime"              = "runtime"), 
                    selected = "critics_score"),
        
        # Select variable for color
        selectInput(inputId = "z", 
                    label = "Color by:",
                    choices = c("Title type" = "title_type", 
                                "Genre" = "genre", 
                                "MPAA rating" = "mpaa_rating", 
                                "Critics rating" = "critics_rating", 
                                "Audience rating" = "audience_rating"),
                    selected = "mpaa_rating")
      ),
      
      # Output
      mainPanel(
        plotOutput(outputId = "scatterplot")
      )
    )
  )
> 
> # Define server function required to create the scatterplot
> server <- function(input, output) {
    
    # Create the scatterplot object the plotOutput function is expecting
    output$scatterplot <- renderPlot({
      ggplot(data = movies, aes_string(x = input$x, y = input$y,
                                       color = input$z)) +
        geom_point()
    })
  }
> 
> # Create a Shiny app object
> shinyApp(ui = ui, server = server)

Listening on http://127.0.0.1:39813
> 
