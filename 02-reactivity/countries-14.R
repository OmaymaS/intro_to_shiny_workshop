## load packages ---------------------------------------------------------------
library(shiny)
library(tidyverse)
library(plotly)

## read data -------------------------------------------------------------------
countries_data <- read_csv("data/countries_1998_2011.csv")

## numeric columns to plot
numeric_columns <- c("human_development_index", "corruption_perception_index",
                     "population", "life_exp", "gdp_per_capita")

## UI ##########################################################################
ui <- fluidPage(
  
  ## application title
  titlePanel("Countries Explorer"),
  
  sidebarLayout(
    
    ## define inputs in sidebar -------------------------------
    sidebarPanel(
      
      # Subtitle
      h4("Data"),
      
      ## select variable for year ---------------------------
      selectInput(inputId = "year", label = "Year",
                  choices = unique(countries_data$year),
                  selected = 2011),
      
      ## add button to save data -----------------------
      ## actionButton(.......)
      
      ## seperate sections ---------
      hr(),
      
      # Subtitle
      h4("Plot"),
      
      ## select variable for scatter plot x-axis --------------
      selectInput(inputId = "x_axis", label = "X axis",
                  choices = numeric_columns,
                  selected = "human_development_index"),
      
      ## select variable for scatter plot y-axis ---------------
      selectInput(inputId = "y_axis", label = "Y axis",
                  choices = numeric_columns,
                  selected = "corruption_perception_index"),
      
      ## select variable for point size in the scatter plot ---------------
      selectInput(inputId = "point_size", label = "Size",
                  choices = c("NULL", "population", "life_exp", "gdp_per_capita"),
                  selected = NULL),
      
      ## set alpha level for points in the scatter plot ----------------
      sliderInput(inputId = "alpha_level", label = "alpha",
                  min = 0, max = 1, value = 0.8),
      
      ## add button to trigger plotting -----------------------
      actionButton(inputId = "plot_button", 
                   label = "Update Plot")
    ),
    
    ## Show output in main panel -----------------------------------------------
    mainPanel(
      plotlyOutput(outputId = "countries_scatter"),
      
      ## add checkbox to show/hide data table -------------------
      checkboxInput(inputId = "show_table", label = "Show table",
                    value = FALSE),
      
      DT::dataTableOutput(outputId = "countries_table")
    )
  )
)

## SERVER ######################################################################
server <- function(input, output) {
  
  ## filter data based on the selected values -------------
  countries_subset <- reactive({
    countries_data %>% 
      filter(year == input$year)
  })
  
  ## write data to csv when save_button is clicked ------------
  ## observeEvent(.......)
  
  ## calculate summaries per continent -----------------
  countries_summary <- reactive({
    countries_subset() %>%
      group_by(continent) %>% 
      summarise(gdp_median = median(gdp_per_capita, na.rm = TRUE),
                life_exp_median = median(life_exp, na.rm = TRUE))
  })
  
  ## create scatter plot ----------------------------------
  output$countries_scatter <- renderPlotly({
    input$plot_button
    
    isolate({
      p_scatter <- ggplot(data = countries_subset(),
                          aes_string(x = input$x_axis, y = input$y_axis,
                                     color = "continent",
                                     size = input$point_size,
                                     label = "country"))+
        geom_point(alpha = input$alpha_level)+
        guides(size = FALSE)+
        labs(title = input$year)+
        theme_minimal()
    })
    
    ggplotly(p_scatter)
  })
  
  ## create data table -------------------------------------
  output$countries_table <- DT::renderDataTable({
    if(input$show_table){
      DT::datatable(countries_summary(), rownames = FALSE)
    }
  })
}

## Run the application #########################################################
shinyApp(ui = ui, server = server)