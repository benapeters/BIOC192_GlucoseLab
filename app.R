library(shiny)
library(rhandsontable)
library(ggplot2)

# Define UI
ui <- fluidPage(
  titlePanel("BIOC192 Lab 4"),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Exercise 2",
               rHandsontableOutput("table1"),
               checkboxInput("toggle", "Show class data", value = FALSE),
               plotOutput("lineplot")
               
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Create reactive values to store data
  values <- reactiveValues(
    initial_data1 = data.frame(
      Time = c(0, 30, 60),
      Student_1 = rep(0, 3),
      Student_2 = rep(0, 3)
    )
  )
  
  # Data for the other 6 students values
  student_data <- data.frame(
    Time = c(0, 30, 60),
    Student_3 = c(5.5, 9.2, 5.2),
    Student_4 = c(4.5, 7.2, 4.2),
    Student_5 = c(3.9, 8.3, 4.1),
    Student_6 = c(5, 7.7, 5.3),
    Student_7 = c(5.2, 8.6, 5),
    Student_8 = c(4.4, 8.8, 4)
  )
  
  # Render tables
  output$table1 <- renderRHandsontable({
    rhandsontable(values$initial_data1) %>%
      hot_col(col = "Time", type = "numeric", readOnly = TRUE) %>%
      hot_col(col = "Student_1", type = "numeric") %>%
      hot_col(col = "Student_2", type = "numeric")
  })
  
  # Observe changes in the table and update data
  observeEvent(input$table1, {
    values$initial_data1 <- hot_to_r(input$table1)
  })
  
  # Render line plot
  output$lineplot <- renderPlot({
    plot_data <- values$initial_data1
    if (input$toggle) {
      plot_data <- merge(plot_data, student_data, by = "Time", all = TRUE)
    }
    p <- ggplot(plot_data, aes(x = Time)) +
      geom_line(aes(y = Student_1, color = "Student_1")) +
      geom_line(aes(y = Student_2, color = "Student_2"))
    
    if (input$toggle) {
      p <- p +
        geom_line(aes(y = Student_3, color = "Student_3"), na.rm = TRUE) +
        geom_line(aes(y = Student_4, color = "Student_4"), na.rm = TRUE) +
        geom_line(aes(y = Student_5, color = "Student_5"), na.rm = TRUE) +
        geom_line(aes(y = Student_6, color = "Student_6"), na.rm = TRUE) +
        geom_line(aes(y = Student_7, color = "Student_7"), na.rm = TRUE) +
        geom_line(aes(y = Student_8, color = "Student_8"), na.rm = TRUE)
    }
    
    p + labs(title = "Line Plot of Initial Data", x = "Time", y = "Value") +
      theme_minimal()
  })
}

# Run the app
shinyApp(ui, server)
