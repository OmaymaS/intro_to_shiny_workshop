library(shiny)


ui <- fluidPage(
  fluidRow(
    column(2,
           "sidebar"
    ),
    column(10,
           "main"
    )
  )
)

server <- function(input, output) {}

shinyApp(ui = ui, server = server)
