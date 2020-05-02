#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(LDAvis)

cluster_name <- "Оцените каждую тему, основываясь на фильмах, которые появляются при нажатии на кружок"

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Movie recomendation on the air"),
  
  # Sidebar with a slider input for number of bins
  navbarPage(cluster_name,
  tabPanel("Классика жанра: IBCF",
           fluidPage(
  sidebarLayout(
    sidebarPanel(
      wellPanel(
      sliderInput("rat_film_1", "Оцените тему 1", min = 1, max = 10, value = 1),
      # uiOutput("Dynamic_Slider2"),
      # uiOutput("Dynamic_Slider3"),
      # uiOutput("Dynamic_Slider4"),
      # uiOutput("Dynamic_Slider5"),
      # uiOutput("Dynamic_Slider107"),
      # uiOutput("Dynamic_Slider124"),
      # uiOutput("Dynamic_Slider54"),
      # uiOutput("Dynamic_Slider253")
       sliderInput("rat_film_2", "Оцените тему 2", min = 0, max = 10, value = 0),
       sliderInput("rat_film_3", "Оцените тему 3", min = 0, max = 10, value = 0),
       sliderInput("rat_film_4", "Оцените тему 4", min = 0, max = 10, value = 0),
       sliderInput("rat_film_5", "Оцените тему 5", min = 0, max = 10, value = 0),
       sliderInput("rat_film_6", "Оцените тему 6", min = 0, max = 10, value = 0),
      sliderInput("rat_film_9", "Оцените тему 9", min = 0, max = 10, value = 0)
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      visOutput('myChart')
      #tableOutput("table")
    )
  )),
  
  tabPanel("Topic modelling",
           fluidPage(
             sliderInput("nTerms", "Number of terms to display", min = 20, max = 40, value = 30),
             DT::dataTableOutput("recomendation")
           ))
  
  
  )
  )
))
