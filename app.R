library(shiny)
library(rhandsontable)
library(ggplot2)

# Define UI
ui <- fluidPage(
  titlePanel("BIOC192 Lab 4"),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Exercise 2",
               rHandsontableOutput("table1")),  

    )
  )
)


# Define server logic
server <- function(input, output) {
  
  # Create initial data for tables
  initial_data1 <- data.frame(
    Amount_of_carbs = rep(NA, 2),
    Before_Snack = rep(NA, 2),
    '30_Minutes' = rep(NA, 2),
    '60_Minutes' = rep(NA, 2)
  )

  
  # Render tables
  output$table1 <- renderRHandsontable({
    rhandsontable(initial_data1)
  })

  
}

# Run the app
shinyApp(ui, server)
