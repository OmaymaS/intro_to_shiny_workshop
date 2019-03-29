library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      numericInput(inputId = "x", label = "X", value = 5),
      numericInput(inputId = "y", label = "Y", value = 10)),
    mainPanel(
      h3("x+y"),
      textOutput("x_plus_y"),
      h3("2*x"),
      textOutput("x_double")
    )
  )
)

server <- function(input, output) {
  
  output$x_plus_y <- renderText({
    input$x+input$y
  })
  
  output$x_double <- renderText({
    2*input$x
  })
}

shinyApp(ui = ui, server = server)
