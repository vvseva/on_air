library(shiny)

library(recommenderlab)
library(dplyr)
library(Hmisc)
library(LDAvis)

m <- matrix(NA,
            nrow=1, ncol=332, dimnames = list(
              user = 561,
              item = item
            ))


cluster_name <- "Оцените хоть первый фильм"

load("matrix.RData")
load("tm.RData")
#load("doc.top.RData")

shinyServer(function(input, output) {
  
  # m1 = reactive({ m[23] <- input$rat_film_1 })
  # m54 = reactive({ m[54] <- input$rat_film_54  })
  # m253 = reactive({ m[253] <- input$rat_film_253  })
  # m7 = reactive({  m[7] <- input$rat_film_7 })
  # m74 = reactive({  m[74] <- input$rat_film_74 })
  # m58 = reactive({  m[58] <- input$rat_film_58 })
  # m128 = reactive({ m[128] <- input$rat_film_128  })
  # m222 = reactive({ m[222] <- input$rat_film_222  })
  
  
  prediction = reactive({
    doc.topics_d <- as.data.frame(doc.topics)
    doc.topics_v <- doc.topics_d[1,]
    doc.topics_v <- as.numeric(doc.topics_v)
    
    doc.topics_v[1] <- input$rat_film_1
    doc.topics_v[3] <- input$rat_film_3
    doc.topics_v[2] <- input$rat_film_2
    doc.topics_v[4] <- input$rat_film_4
    doc.topics_v[5] <- input$rat_film_5
    doc.topics_v[6] <- input$rat_film_6
    doc.topics_v[9] <- input$rat_film_9
    
    
    
    my_corr <- function(x) {
      cor(doc.topics_v, as.numeric(x), method="spearman")
    }
    
    doc.topics_d$corrr <-  apply(doc.topics_d, 1, my_corr)
    
    pred_num <- doc.topics_d %>% mutate(user =  row_number()) %>% filter(corrr == max(corrr)) # %>% select(user))
    pred_num <-  pred_num %>% select(user, corrr)
    
    nice_recc <- as.data.frame(data_text_all %>% filter(user == pred_num$user, rat == "POS") %>% mutate(userID = pred_num$user) %>% select(all_movies, userID))
    nice_recc_sp <-  strsplit(nice_recc$all_movies, " ")
    nice_recc_sp <- as.data.frame(nice_recc_sp)
    nice_recc_sp <- na.omit(nice_recc_sp)
    nice_recc_sp <- nice_recc_sp[nice_recc_sp != "" ]
    nice_recc_sp <- as.data.frame(nice_recc_sp)
    nice_recc_sp <- sample_n(nice_recc_sp, 10)
    nice_recc_sp$rating <- 5
    nice_recc_sp$corelation <- pred_num$corrr
    nice_recc_sp
    # r <- as(m, "realRatingMatrix")
    # recc_predicted = predict(object = recc_model, newdata = r[1,], n = 7)
    # movies_user_2 = recc_predicted@itemLabels[recc_predicted@items[[1]]]
    # movies_user_2 = as.data.frame(movies_user_2)
    # movies_user_2
    # movies_user_2$ratrec <- recc_predicted@ratings[["561"]]
    # nice_rec <- movies_user_2 
    # nice_rec
    })

  
  # output$Dynamic_Slider2 = renderUI({
  #   if (input$rat_film_1 >= 4) {
  #     sliderInput("rat_film_54", "Terminator 2: Judgment Day (1991)", min = 1, max = 5, value = 1) 
  #     }
  #   else {
  #     sliderInput("rat_film_253", "Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb (1963)", min = 1, max = 5, value = 1)
  #   }
  # })
  # 
  # output$Dynamic_Slider253 <- renderUI({
  #     if (input$rat_film_253 >= 4) {
  #       sliderInput("rat_film_124", "Back to the Future (1985)", min = 1, max = 5, value = 1)
  #       }
  #     else {
  #       sliderInput("rat_film_107", "Psycho (1960)", min = 1, max = 5, value = 1)
  #     }
  # 
  #   })
  # 
  # output$Dynamic_Slider54 <- renderUI({ 
  #   
  #   if (input$rat_film_54 >= 4) {
  #     sliderInput("rat_film_74", "A Space Odyssey (1968)", min = 1, max = 5, value = 1)
  #   }
  #   else { 
  #     sliderInput("rat_film_7", "Seven (Se7en) (1995)", min = 1, max = 5, value = 1)
  #   }
  #   })
  # 
  # output$Dynamic_Slider124 <- renderUI({
  #   if (input$rat_film_124 >= 4) {
  #     sliderInput("rat_film_128", "Indiana Jones and the Last Crusade (1989)", min = 1, max = 5, value = 1)
  #   }
  #   else sliderInput("rat_film_58", "Fargo (1996)", min = 1, max = 5, value = 1)
  # })
  # 
  # 
  # output$Dynamic_Slider107 <- renderUI({
  #   if (input$rat_film_107 >= 4) {
  #     sliderInput("rat_film_74", "A Space Odyssey (1968)", min = 1, max = 5, value = 1)
  #   }
  #   else sliderInput("rat_film_58", "Fargo (1996)", min = 1, max = 5, value = 1)
  # })
  # 
  # 
  # 
  # output$Dynamic_Slider5 <- renderUI({
  # 
  #   sliderInput("rat_film_222", "Star Trek: Generations (1994)", min = 1, max = 5, value = 1)
  # 
  # })
  
  # trainTest2 = reactive({
  #   loading_table <- data_frame(Loading = "Хз чё так долго, должно прям сейчас")
  #   data_2 <- trainTest()
  #   if (is.null(data_2))loading_table
  #   else data_2
  # })
  
  output$recomendation <- DT::renderDataTable({
    prediction()
  })
  
  # output$table = renderDataTable(
  #   prediction()
  # )
  # output$user <- DT::renderDataTable({
  #   pred_num
  # })
  
  output$myChart <- renderVis({
    if(!is.null(input$nTerms)){
           createJSON(phi = topic.words, theta=doc.topics, 
      doc.length=doc.length, vocab=vocabulary, 
      term.frequency=word.freqs$term.freq, R = input$nTerms)
      
      
    } 
  })
  
  
})
