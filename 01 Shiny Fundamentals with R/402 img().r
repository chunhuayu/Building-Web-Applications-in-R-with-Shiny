### Add image with img tag

# Images can enhance the appearance of your app, and you can add images to a Shiny app with the img() tag.

### Instructions
# Add two line breaks to set the images apart visually.
# Specify the text to be added, "Built with Shiny by RStudio.", as a fifth level header.
# Instead of the word "Shiny" use the hex logo at https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png, 
# specifying a height of 30px.
# Instead of the word "RStudio" use the logo at 
# https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png, specifying a height of 30px as well.

### R

> library(shiny)
> library(ggplot2)
> library(stringr)
> library(dplyr)
> library(DT)
> library(tools)
> load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))
> 
> # Define UI for application that plots features of movies
> ui <- fluidPage(
    
    # Sidebar layout with a input and output definitions
    sidebarLayout(
      
      # Inputs
      sidebarPanel(
        
        h3("Plotting"),      # Third level header: Plotting
        
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
        
        # Enter text for plot title
        textInput(inputId = "plot_title", 
                  label = "Plot title", 
                  placeholder = "Enter text to be used as plot title"),
        
        hr(),                # Horizontal line for visual separation
        
        h3("Subsetting"),    # Third level header: Subsetting
        
        # Select which types of movies to plot
        checkboxGroupInput(inputId = "selected_type",
                           label = "Select movie type(s):",
                           choices = c("Documentary", "Feature Film", "TV Movie"),
                           selected = "Feature Film"),
        
        hr(),                # Horizontal line for visual separation
        
        # Show data table
        checkboxInput(inputId = "show_data",
                      label = "Show data table",
                      value = TRUE),
        
        # Built with Shiny by RStudio
        br(), br(),
        h5("Built with",
           img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
           "by",
           img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
           ".")
        
      ),
      
      # Output:
      mainPanel(
        
        h3("Scatterplot"),    # Third level header: Scatterplot
        plotOutput(outputId = "scatterplot"),
        br(),                 # Single line break for a little bit of visual separation
        
        h5(textOutput("description")), # Fifth level header: Description
        
        h3("Data table"),     # Third level header: Data table
        DT::dataTableOutput(outputId = "moviestable")
      )
    )
  )
> 
> # Define server function required to create the scatterplot
> server <- function(input, output, session) {
    
    # Create a subset of data filtering for selected title types
    movies_selected <- reactive({
      req(input$selected_type) # ensure availablity of value before proceeding
      filter(movies, title_type %in% input$selected_type)
    })
    
    # x and y as reactive expressions
    x <- reactive({ toTitleCase(str_replace_all(input$x, "_", " ")) })
    y <- reactive({ toTitleCase(str_replace_all(input$y, "_", " ")) })
    
    # Create scatterplot object the plotOutput function is expecting 
    output$scatterplot <- renderPlot({
      ggplot(data = movies_selected(), aes_string(x = input$x, y = input$y)) +
        geom_point() +
        labs(x = x(),
             y = y(),
             color = toTitleCase(str_replace_all(input$z, "_", " ")),
             title = toTitleCase(input$plot_title))
    })
    
    # Create description of plot
    output$description <- renderText({
      paste("The plot above shows the relationship between",
            x(),
            "and",
            y(),
            "for",
            nrow(movies_selected()),
            "movies.")
    })
    
    # Print data table if checked
    output$moviestable <- DT::renderDataTable(
      if(input$show_data){
        DT::datatable(data = movies_selected()[, 1:6], 
                      options = list(pageLength = 10), 
                      rownames = FALSE)
      }
    )
    
  }
> 
> # Create Shiny app object
> shinyApp(ui = ui, server = server)

Attaching package: 'dplyr'

The following objects are masked from 'package:stats':

    filter, lag

The following objects are masked from 'package:base':

    intersect, setdiff, setequal, union


Attaching package: 'DT'

The following objects are masked from 'package:shiny':

    dataTableOutput, renderDataTable


Listening on http://127.0.0.1:46247
> 
