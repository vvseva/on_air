#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(rvest)
library(shiny)
library(stringr)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Generation of an insult and an target"),
    
    # action Button
    actionButton("do", "Click Me"),
    
    # Sidebar with a slider input for number of bins 
    h1(textOutput("insult1"))
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    names <- c(rep("Seva", 2), rep("Andre", 2), rep("Cristine", 4), rep("Nastya", 4), rep("Putin", 1))
    insult <- read_html("http://www.insult.wiki/wiki/Insult_List")
    insults <- insult %>% html_nodes("ol a") %>% html_attr("title") %>% substring(4)
    
    observeEvent(input$do, {
        output$insult1 <-  renderText(str_c(sample(insults, 1), sample(names, 1), sep = " "))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
