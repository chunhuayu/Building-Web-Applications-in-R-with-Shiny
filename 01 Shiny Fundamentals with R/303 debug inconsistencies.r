### Find inconsistencies in what the app is reporting

# This exercise features an app where the user can select a random sample of desired title types. 
# The app then reports the frequencies of various title types in the sample and plots user selected variables for these data. 
# There are two new functions of note in the server: observeEvent() and updateNumericInput(). 
# We use them to update the numeric input widget to display a maximum allowed sample size based on the selected title types. 
# For example, if you only select "TV Movie", the maximum allowed sample size is 5, 
# because there are only 5 TV movies in the sample. We'll learn more about observeEvent() later in the course. 
# For now, your task is simple: find the mismatched use of reactives.

### Instructions

# Run the sample code and view the app. 
# (1) Does the sample size the user inputs match the sample size displayed in the text on top of the app? 
# (2) Does it match the counts displayed in the title type frequency table? (3) How about the number of points plotted?
# If your answers to any of the three questions above is no, debug the app code accordingly.
# Run the app code again to verify that your answer to all three questions above is yes.

### R

> library(shiny)
> library(ggplot2)
> library(dplyr)
> load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))
> 
> # UI
> ui <- fluidPage(
    sidebarLayout(
      
      # Input(s)
      sidebarPanel(
        
        # Select which types of movies to plot
        checkboxGroupInput(inputId = "selected_type",
                           label = "Select movie type(s):",
                           choices = c("Documentary", "Feature Film", "TV Movie"),
                           selected = "Feature Film"),
        
        # Select sample size
        numericInput(inputId = "n_samp", 
                     label = "Sample size:", 
                     min = 1, max = nrow(movies), 
                     value = 3),
        
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
                    selected = "critics_score")
  
      ),
      
      # Output(s)
      mainPanel(
        htmlOutput(outputId = "sample_info"),
        br(), br(),
        tableOutput(outputId = "sample_tt_info"),
        br(),
        plotOutput(outputId = "scatterplot")
      )
    )
  )
> 
> # Server
> server <- function(input, output, session) {
    
    # Filter movies for selected title types
    movies_selected <- reactive({
      req(input$selected_type)
      filter(movies, title_type %in% input$selected_type)
    })
    
    # Update max allowed sample size in the numeric input widget
    # when input$selected_type changes
    observeEvent(input$selected_type, {
      # Calculate max sample size
      n_max <- nrow(movies_selected())
      # Update max value widget accepts
      updateNumericInput(session, "n_samp", max = n_max)
      # Update label displayed to user
      updateNumericInput(session, "n_samp", 
                         label = paste0("Sample size (max = ", n_max, "):"))
    })
    
    # Sample n_samp movies of selected title types
    movies_sample <- reactive({ 
      req(input$n_samp)
      sample_n(movies_selected(), input$n_samp)
    })
    
    # Display number of sampled movies
    output$sample_info <- renderUI({
      paste(input$n_samp,
            "movies are sampled. The table below shows the frequencies of title 
            types in your sample.")
    })
    
    # Tabulate frequencies of types of sampled movies
    output$sample_tt_info <- renderTable({
      movies_sample() %>% 
        count(title_type) %>%
        rename(`Title type` = title_type, Frequency = n)
    })
    
    # Plot sampled movies
    output$scatterplot <- renderPlot({
      ggplot(data = movies_sample(), aes_string(x = input$x, y = input$y)) +
        geom_point()
    })
    
  }
> 
> # Create a Shiny app object
> shinyApp(ui = ui, server = server)

Attaching package: 'dplyr'

The following objects are masked from 'package:stats':

    filter, lag

The following objects are masked from 'package:base':

    intersect, setdiff, setequal, union


Listening on http://127.0.0.1:45791
> 


######## original server body 
# Server
server <- function(input, output, session) {
  
  # Filter movies for selected title types
  movies_selected <- reactive({
    req(input$selected_type)
    filter(movies, title_type %in% input$selected_type)
  })
  
  # Update max allowed sample size in the numeric input widget
  # when input$selected_type changes
  observeEvent(input$selected_type, {
    # Calculate max sample size
    n_max <- nrow(movies_selected())
    # Update max value widget accepts
    updateNumericInput(session, "n_samp", max = n_max)
    # Update label displayed to user
    updateNumericInput(session, "n_samp", 
                       label = paste0("Sample size (max = ", n_max, "):"))
  })
  
  # Sample n_samp movies of selected title types
  movies_sample <- reactive({ 
    req(input$n_samp)
    sample_n(movies_selected(), input$n_samp)
  })
  
  # Display number of sampled movies
  output$sample_info <- renderUI({
    paste(input$n_samp,
          "movies are sampled. The table below shows the frequencies of title 
          types in your sample.")
  })
  
  # Tabulate frequencies of types of sampled movies
  output$sample_tt_info <- renderTable({
    movies_selected() %>% 
      count(title_type) %>%
      rename(`Title type` = title_type, Frequency = n)
  })
  
  # Plot sampled movies
  output$scatterplot <- renderPlot({
    ggplot(data = movies_selected(), aes_string(x = input$x, y = input$y)) +
      geom_point()
  })
  
}
