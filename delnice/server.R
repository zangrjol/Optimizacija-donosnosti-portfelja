library(shiny)
library(dplyr)
library(RPostgreSQL)

source("auth.R")

shinyServer(function(input, output) {
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  tabela <- tbl(conn, "delnice")
  
  output$delnice <- renderTable({
    t <- data.frame(select(arrange(filter(tabela, simbol %in% (input$ime) & cena > input$stevilo & 
                                            datum >= input$datum[1] & datum <= input$datum[2]),simbol),c(simbol,cena)))
    t
  })
  
  output$delnice2 <- renderTable({
    t <- data.frame(select(arrange(filter(tabela, simbol %in% (input$ime2) & cena > input$stevilo & 
                                            datum >= input$datum[1] & datum <= input$datum[2]),simbol),c(simbol,cena)))
    t
  })
  
  output$date <- renderTable({
    t <- data.frame(select(arrange(filter(tabela, simbol %in% (input$ime2) & cena > input$stevilo & 
                                            datum >= input$datum[1] & datum <= input$datum[2]),simbol),datum))
    t$datum <- as.character(t$datum)
    t
  })
})