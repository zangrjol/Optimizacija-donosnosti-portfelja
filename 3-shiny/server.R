library(shiny)
library(dplyr)
library(RPostgreSQL)

source("auth.R")

shinyServer(function(input, output) {
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  tabela <- tbl(conn, "delnice")
  tabelaImen <- tbl(conn,"imena")
  skupnaTabela <- inner_join(tabela,tabelaImen, by = "simbol")
  
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

  output$endatum <- renderUI({
    datumMAX <- data.frame(summarize(select(tabela,datum),max(datum)))
    dateInput("endatum", label ="Izberi datum za izpis Sharpovih vrednosti:",value=datumMAX[1,1],
              weekstart=1,format="dd.mm.yyyy")
  })

  output$sharp <- renderTable({
    head(select(arrange(filter(tabela, datum == input$endatum),desc(sharp)),c(simbol,cena,sharp)),input$koliko)
  })

  output$naslov <- renderText({
    paste("Najboljsih",input$koliko,"delnic")
  })

  output$graf <- renderPlot({
    datumi <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[2]),datum))
    cene <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[2]),cena))
    cene1 <- data.frame(select(filter(tabela,simbol %in% (input$ime) & datum >= input$datum[1] & datum <= input$datum[2]),cena))
    plot(datumi[,1],cene[,1],'l',col="red",main=paste("Gibanje cen delnic",input$select),ylab="price",xlab="")
#     par(new=TRUE)
#     plot(datumi[,1],cene1[,1],'l',ylim=range(min(cene[,1],cene1[,1]),max(cene[,1],cene1[,1])),xlab="",ylab="",col="green")
#     legend("topleft",legend=c(input$select,input$ime),col=c("red","green"),lty=c(1,1))
  })

  output$graf1 <- renderPlot({
    datumi <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[2]),datum))
    cene <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[2]),cena))
    cene1 <- data.frame(select(filter(tabela,simbol %in% (input$ime) & datum >= input$datum[1] & datum <= input$datum[2]),cena))
    #     par(new=TRUE)
    plot(datumi[,1],cene1[,1],'l',main=paste("Gibanje cen delnic",input$ime), 
        xlab="",ylab="price",col="red")
    #legend("topleft",legend=c(input$select,input$ime),col=c("red","green"),lty=c(1,1))
  })

  output$graf2 <- renderPlot({
    zacetna1 <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[1]),cena))
    if (nrow(zacetna1) == 0) {
      datumi <- data.frame(0)
      cene <- 0
      cene1 <- 0
      tip = "n"
    } else {
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
      tip = "l"
    }
    plot(datumi[,1],cene,tip,col="red",main=paste("Relativizirane cene",input$select,"in",input$ime),xlab="",ylab="",
        ylim=range(min(cene,cene1),max(cene,cene1)))
    lines(datumi[,1],cene1,ylim=range(min(cene,cene1),max(cene,cene1)),xlab="",ylab="",col="green")
    if (tip =="l") {
      abline(h=1,lty=3)
      legend("topleft",legend=c(input$select,input$ime),col=c("red","green"),lty=c(1,1))
    }
    if (tip == "n") {
      text(0, (cene+cene1)/2, "Na ta dan ni podatkov!", cex = 2.5, col = "red")
    }
  })

  output$datum <- renderUI({
    datumMAx <- data.frame(summarize(select(tabela,datum),max(datum)))
    datumMIN <- data.frame(summarize(select(tabela,datum),min(datum)))
    dateRangeInput("datum",label="Izberi interval za primerjavo:",start=datumMIN[1,1],
                   end=datumMAx[1,1],language="sl", separator = "do", weekstart = 1, format = "dd.mm.yyyy")
  })

  output$opozorilo <- renderUI({
    datumMIN <- data.frame(summarize(select(tabela,datum),min(datum)))
    helpText(h6(paste("*Opozorilo: Izberi datum od", datumMIN[1,1], "naprej"),col = "#FF0000" ,align = "center"))
    })

})