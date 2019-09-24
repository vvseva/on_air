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
    
    #language
    selectInput(inputId = "language",
                label = "Select a language:",
                choices = c("General", "Glorious")),
    
    # action Button
    actionButton("do", "Click Me"),
    
    # Sidebar with a slider input for number of bins 
    h1(textOutput("insult1"))
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    observe({
        if (input$language == "General" ){
            names <- c(rep("Seva", 20), rep("Andre", 20), rep("Christina", 30), 
                       rep("Nastya", 30), rep("Putin", 1))
            
            insults <- read_html("http://www.insult.wiki/wiki/Insult_List") %>% html_nodes("ol a") %>% html_attr("title") %>% substring(4)
            
        } else {
            names <- c(rep("Seva", 20), rep("Andre", 20), rep("Christina", 30), 
                       rep("Nastya", 30), rep("Putin", 1))
            
            insults <- read_html("http://www.insult.wiki/wiki/Schimpfwort-Liste") %>% html_nodes("ol a") %>% html_attr("title") %>% substring(4)
            
            names <- stringr::str_c("Der", names, sep = " ")
        }
        
        observeEvent(input$do, {
            output$insult1 <-  renderText(str_c(sample(insults, 1), 
                                                sample(names, 1), sep = " "))
        })
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
