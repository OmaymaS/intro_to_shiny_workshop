# Load packages -----------------------------------------------------
library(shiny)
library(shinydashboard)
library(tidyverse)

# Load data ---------------------------------------------------------
tweets <- readRDS("./data/rstats_tweets.rds")

## UI ##########################################################################
ui <- dashboardPage(
  
  ## Header
  dashboardHeader(title = "#rstats Tweets"),
  
  ## Sidebar
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Details", tabName = "details", icon = icon("users"))
    )
  ),
  
  ## Body
  dashboardBody(
    
      ## title about the content
      h2("Twitter #rstats hashtag activities"),
    
    tabItems(
      
      ## Tab 1: home  -----------------------------------------------------------
      tabItem(
        tabName = "home",
        
        ## subtitle in home tab 
        h3("Overview (Jan 2015 - Dec 2018)"),
        
        fluidRow(
          
          ## Value box: number of tweets -----------------
          valueBox(
            width = 6,
            sum(tweets$all_tweets),
            "Original Tweets", 
            icon = icon("twitter")
          ),
          
          ## value box: number of unique users -------------
          valueBox(
            width = 6,
            n_distinct(tweets$user_id), 
            "Unique Users", 
            icon = icon("user"),
            color = "green"
          )
        ),
        
        ## info about dataset ------------
        tags$p("Subset of the original data published by", tags$a("Mike Kearney", href = "https://twitter.com/kearneymw"),
               tags$br(),
               "Dataset available in", tags$a("tidytuesday datasets", href = "https://github.com/rfordatascience/tidytuesday/blob/master/data/2019/2019-01-01/rstats_tweets.rds"))
        
      ),
      
      ## Tab 2: details ---------------------------------------------------------
      tabItem(
        tabName = "details",
        
        ## left column --------------------------------
        column(width = 4,
               fluidRow(
                 
                 ## box with select input for user name ----------------------
                 box(width = 12,
                     title = "Select User Name",
                     status = "primary",
                     selectizeInput(inputId = "screen_name_input", label = "screen name",
                                    choices = unique(tweets$screen_name),
                                    selected = "dataandme"))
               ),
               
               fluidRow(
                 
                 ## show value box "tweets_count" --------------
                 valueBoxOutput(width = 12,
                                "tweets_count")
               ),
               
               h4("Interactions"),
               
               ## show value box "favourites_count" -------------
               fluidRow(
                 valueBoxOutput(width = 12,
                                "favourites_count")
               ),
               
               ## show value box "retweets_count" ---------------
               fluidRow(
                 valueBoxOutput(width = 12,
                                "retweets_count")
               )
               
        ),
        
        ## right column --------------
        column(width = 8,
               fluidRow(
                 
                 ## box with plot output "tweets_plots" ---------
                 box(width = 12,
                     title = "Tweets over time",
                     status = "primary",
                     plotOutput("tweets_plots")
                 )
               ))
      )
    )
  )
)

## SERVER ######################################################################
server <- function(input, output) {
  
  ## filter data by selected screen_name ---------------
  user_records <- reactive({
    tweets %>% 
      filter(screen_name == input$screen_name_input)
  })
  
  ## render value box: number of user tweets ---------------
  output$tweets_count <- renderValueBox({
    valueBox(sum(user_records()$all_tweets),
             "All Tweets", 
             icon = icon("twitter"))
  })
  
  ## render value box: number of favourites ---------------
  output$favourites_count <- renderValueBox({
    valueBox(sum(user_records()$favourites),
             "Favourites", 
             icon = icon("heart"),
             color = "purple")
  })
  
  ## render value box: number of user retweets ---------------
  output$retweets_count <- renderValueBox({
    valueBox(sum(user_records()$retweets),
             "Retweets", 
             icon = icon("retweet"),
             color = "green")
  })
  
  ## render plot: user tweets over time ------------------
  output$tweets_plots <- renderPlot({
    user_records() %>% 
      ggplot(aes(x = year_mon, y = original_tweets))+
      zoo::scale_x_yearmon(format="%b %Y")+
      geom_line()+
      geom_point()+
      theme_minimal()
  })
}

## Run the application #########################################################
shinyApp(ui, server)
