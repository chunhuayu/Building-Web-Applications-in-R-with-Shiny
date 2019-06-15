### Convert dateInput to dateRangeInput

# The app on the right can be used to display movies from a particular date onwards. 
# Instead we would like to select movies between two given dates. 
# Hence we need to convert the dateInput widget to a dateRangeInput widget. 
# This input will yield a vector (input$date) of length two, 
# where the first element is the start date and the second is the end date.

# Review the help files for the two widgets by typing ?dateInput and ?dateRangeInput in the console.

# In this exercise you will only need to update the dateInput widget.
# The accompanying updates have already been made in the helper text in the UI as well as in the server function.

### Instructions

# Update dateInput to dateRangeInput.
# Replace the value argument with the arguments start = "2013-01-01" and end = "2014-01-01".
# Update the label to "Select dates:"
# Add a startview argument, and set it to "year" to make it a bit easier for the user to navigate the calendar.

### R Script

library(shiny)
library(dplyr)
library(ggplot2)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

min_date <- min(movies$thtr_rel_date)
max_date <- max(movies$thtr_rel_date)

# UI
ui <- fluidPage(
    sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      
      # Explanatory text
      HTML(paste0("Movies released between the following dates will be plotted. 
                  Pick dates between ", min_date, " and ", max_date, ".")),
      
      # Break for visual separation
      br(), br(),
      
      # Date input
      dateRangeInput(inputId = "date",
                label = "Select dates:",startview = "year",
                start = "2013-01-01", end = "2014-01-01",
                min = min_date, max = max_date)
    ),
    
    # Output(s)
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Create the plot
  output$scatterplot <- renderPlot({
    req(input$date)
    movies_selected_date <- movies %>%
      mutate(thtr_rel_date = as.Date(thtr_rel_date)) %>% # convert thtr_rel_date to Date format
      filter(thtr_rel_date >= input$date[1] & thtr_rel_date <= input$date[2])
    ggplot(data = movies_selected_date, aes(x = critics_score, y = audience_score, color = mpaa_rating)) +
      geom_point()
  })
  
}
# Create a Shiny app object
shinyApp(ui = ui, server = server)
