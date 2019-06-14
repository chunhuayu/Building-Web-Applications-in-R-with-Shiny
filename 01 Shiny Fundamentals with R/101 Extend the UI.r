### Extend the UI

# We'll start our learning with a simplified version of the app you saw in the previous exercise. 
# In this app a selectInput widget is used to allow the user to select which variables should be plotted on the x 
# and y axes of the scatterplot.

# The selectInput function has four arguments: an inputId that is used to refer to the input parameter 
# when building the scatterplot, a label that is displayed in the app, a list of choices to pick from, 
# and a selected choice for when the app first launches. Note that choices takes a named vector, 
# and the name rather than the value (which must match variable names in the data frame) is displayed to the user.

### Instructions
# Add a new selectInput widget at line 27 to color the points by a choice of the following variables: 
# "title_type", "genre", "mpaa_rating", "critics_rating", "audience_rating". 
# Set the inputId = "z" and the label = "Color by:".
# Make the default selection "mpaa_rating".


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
                    choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                    selected = "audience_score"),
        
        # Select variable for x-axis
        selectInput(inputId = "x", 
                    label = "X-axis:",
                    choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                    selected = "critics_score"),
        
        # Select variable for color
        selectInput(inputId = "z", 
                    label = "Color by:",
                    choices = c("title_type","genre","mpaa_rating","critics_rating","audience_rating"),
                    selected = "mpaa_rating")
      ),
      
      # Outputs
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

Listening on http://127.0.0.1:33459
> 
