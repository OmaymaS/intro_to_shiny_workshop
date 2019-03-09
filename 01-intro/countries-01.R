## load packages ---------------------------------------------------------------
library(shiny)
library(tidyverse)

## read data -------------------------------------------------------------------
countries_data <- read_csv("data/countries_1998_2011.csv")

## subset data
countries_data_2011 <- countries_data %>% 
  filter(year == 2011)

## numeric columns to plot
numeric_columns <- c("human_development_index", "corruption_perception_index",
                     "population", "life_exp", "gdp_per_capita")

## UI ##########################################################################
ui <- fluidPage(

  sidebarLayout(
    
    ## define inputs in sidebar -------------------------------
    sidebarPanel(
      
      ## select variable for scatter plot x-axis --------------
      selectInput(inputId = "x_axis", label = "X axis",
                  choices = numeric_columns,
                  selected = "human_development_index"),
      
      ## select variable for scatter plot y-axis ---------------
      selectInput(inputId = "y_axis", label = "Y axis",
                  choices = numeric_columns,
                  selected = "corruption_perception_index")
    ),
    
    ## Show output in main panel -----------------------------------------------
    mainPanel(
      ## show plot
      plotOutput(outputId = "countries_scatter")
    )
  )
)

## SERVER ######################################################################
server <- function(input, output) {
  
  ## create scatter plot ----------------------------------
  output$countries_scatter <- renderPlot({
    ggplot(data = countries_data_2011,
           aes_string(x = input$x_axis, y = input$y_axis,
                      color = "continent"))+
      geom_point()+
      theme_minimal()
  })
}

## Run the application #########################################################
shinyApp(ui = ui, server = server)