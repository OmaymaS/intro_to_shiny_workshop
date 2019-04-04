library(shiny)

ui <- fluidPage(
  fluidRow(
    column(4,
           "4"
    ),
    column(2, offset = 2,
           "4 offset 4"
    )      
  ),
  fluidRow(
    column(2, offset = 2,
           "3 offset 3"
    ),
    column(3, offset = 3,
           "3 offset 3"
    )  
  )
)



server <- function(input, output) {}

shinyApp(ui = ui, server = server)