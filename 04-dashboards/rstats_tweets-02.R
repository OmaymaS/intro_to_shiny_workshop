# Load packages -----------------------------------------------------
library(shiny)
library(shinydashboard)
library(tidyverse)

# Load data ---------------------------------------------------------
tweets <- readRDS("./data/rstats_tweets.rds")

# Define UI ---------------------------------------------------------
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
    
    tabItems(
      
      ## Tab 1: home  -----------------------------------------------------------
      tabItem(
        tabName = "home",
        
        ## title about home tab content
        h2("Twitter #rstats hashtag activities"),
        h4("(Jan 2015 to Dec 2018)"),
        
        fluidRow(
          ## Value box: number of tweets
          valueBox(
            width = 6,
            sum(tweets$all_tweets),
            "Original Tweets", 
            icon = icon("twitter")
          ),
          
          ## value box: number of unique users
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
        tabName = "details"
      )
    )
  )
)

## Define server function --------------------------------------------
server <- function(input, output) {
}

## Create the Shiny app object ---------------------------------------
shinyApp(ui, server)
