library(shiny)
library(dplyr)
library(RPostgreSQL)

source("auth.R")

shinyServer(function(input, output) {
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  tabela <- tbl(conn, "delnice")
  tabelaImen <- tbl(conn,"imena")
  skupnaTabela <- merge(tabela,tabelaImen, by = "simbol")
  
  output$delnice <- renderTable({
    t <- data.frame(select(arrange(filter(tabela, simbol %in% (input$select) & cena > input$stevilo & 
                                            datum >= input$datum[1] & datum <= input$datum[2]),simbol),c(simbol,(datum),cena)))
    t
  })

#   output$delnice <- renderTable({
#     t <- data.frame(filter(tabela, simbol == input$select, datum >= input$datum[1] & datum <= input$datum[2]))
#     t
#   })
  
  output$delnice2 <- renderTable({
    t <- data.frame(arrange(filter(tabela, simbol %in% (input$ime2) & cena > input$stevilo & 
                                            datum >= input$datum[1] & datum <= input$datum[2]),simbol))
    t
  })
  

#   output$date <- renderTable({
#     t <- data.frame(select(arrange(filter(tabela, simbol %in% (input$ime2) & cena > input$stevilo & 
#                                             datum >= input$datum[1] & datum <= input$datum[2]),simbol),datum))
#     t$datum <- as.character(t$datum)
#     t
#   })

  output$sharp <- renderTable({
    t <- data.frame(select(arrange(filter(tabela, datum == input$endatum),sharp),c(simbol,cena,sharp)))
    t <- t[order(-t$sharp),]
    t <- t[1:input$koliko,]
    t
  })

  output$naslov <- renderText({
    paste("Najboljsih",input$koliko,"delnic")
  })

  output$graf <- renderPlot({
    datumi <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[2]),datum))
    cene <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[2]),cena))
    cene1 <- data.frame(select(filter(tabela,simbol %in% (input$ime) & datum >= input$datum[1] & datum <= input$datum[2]),cena))
    plot(datumi[,1],cene[,1],'l',col="red",main=paste("Gibanje cen delnic",input$select,"in",input$ime),xlab="cas",ylab="vrednost",
         ylim=range(min(cene[,1],cene1[,1]),max(cene[,1],cene1[,1])))
    par(new=TRUE)
    plot(datumi[,1],cene1[,1],'l',ylim=range(min(cene[,1],cene1[,1]),max(cene[,1],cene1[,1])),xlab="",ylab="",col="green")
    legend("topleft",legend=c(input$select,input$ime),col=c("red","green"),lty=c(1,1))
  })
  output$graf2 <- renderPlot({
    zacetna1 <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[1]),cena))
    zacetna2 <- data.frame(select(filter(tabela,simbol %in% (input$ime) & datum >= input$datum[1] & datum <= input$datum[1]),cena))
    datumi <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[2]),datum))
    cene <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[2]),cena))
    cene1 <- data.frame(select(filter(tabela,simbol %in% (input$ime) & datum >= input$datum[1] & datum <= input$datum[2]),cena))
    zacetna1 <- zacetna1[,1]
    zacetna2 <- zacetna2[,1]
    cene <- cene[,1]
    cene1 <- cene1[,1]
    cene <- cene/zacetna1
    cene1 <- cene1/zacetna2
    plot(datumi[,1],cene,'l',col="red",main=paste("Relativizirane cene",input$select,"in",input$ime),xlab="cas",ylab="vrednost",
        ylim=range(min(cene,cene1),max(cene,cene1)))
    par(new=TRUE)
    plot(datumi[,1],cene1,'l',ylim=range(min(cene,cene1),max(cene,cene1)),xlab="",ylab="",col="green")
    abline(h=1,lty=3)
    legend("topleft",legend=c(input$select,input$ime),col=c("red","green"),lty=c(1,1))
})

})