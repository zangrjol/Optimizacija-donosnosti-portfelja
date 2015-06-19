library(shiny)
library(dplyr)
library(RPostgreSQL)

source("auth-public.R")

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
    dateInput("endatum", label ="Izberi datum za izpis Sharpovih vrednosti:",value=as.Date(datumMAX[1,1]+1),
              weekstart=1,format="dd.mm.yyyy")
  })
  
  
  output$naslov <- renderText({
    paste("Najboljsih",input$koliko,"delnic")
  })
  
  output$graf <- renderPlot({
    if (is.null(input$datum)) {
      text(0, 0, " ")
    } else{
      datumi <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[2]),datum))
      cene <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[2]),cena))
      cene1 <- data.frame(select(filter(tabela,simbol %in% (input$ime) & datum >= input$datum[1] & datum <= input$datum[2]),cena))
      plot(datumi[,1],cene[,1],'l',col="red",main=paste("Gibanje cen delnic",input$select),ylab="price",xlab="")
      #     par(new=TRUE)
      #     plot(datumi[,1],cene1[,1],'l',ylim=range(min(cene[,1],cene1[,1]),max(cene[,1],cene1[,1])),xlab="",ylab="",col="green")
      #     legend("topleft",legend=c(input$select,input$ime),col=c("red","green"),lty=c(1,1))
    }
  })
  
  output$graf1 <- renderPlot({
    if (is.null(input$datum)) {
      text(0, 0," ")
    } else {
      datumi <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[2]),datum))
      cene <- data.frame(select(filter(tabela,simbol %in% (input$select) & datum >= input$datum[1] & datum <= input$datum[2]),cena))
      cene1 <- data.frame(select(filter(tabela,simbol %in% (input$ime) & datum >= input$datum[1] & datum <= input$datum[2]),cena))
      #     par(new=TRUE)
      plot(datumi[,1],cene1[,1],'l',main=paste("Gibanje cen delnic",input$ime), 
           xlab="",ylab="price",col="red")
      #legend("topleft",legend=c(input$select,input$ime),col=c("red","green"),lty=c(1,1))
    }
  })
  
  output$graf2 <- renderPlot({
    datumi <- data.frame(0)
    cene <- 0
    cene1 <- 0
    tip = "n"
    if (!is.null(input$datum1)) {
      zacetna1 <- data.frame(select(filter(tabela,simbol %in% (input$select1) & datum == input$datum1[1]),cena))
      if (nrow(zacetna1) > 0) {
        zacetna1 <- data.frame(select(filter(tabela,simbol %in% (input$select1) & datum == input$datum1[1]),cena))
        zacetna2 <- data.frame(select(filter(tabela,simbol %in% (input$ime1) & datum == input$datum1[1]),cena))
        datumi <- data.frame(select(filter(tabela,simbol %in% (input$select1) & datum >= input$datum1[1]& datum <= input$datum1[2]),datum))
        cene <- data.frame(select(filter(tabela,simbol %in% (input$select1) & datum >= input$datum1[1] & datum <= input$datum1[2]),cena))
        cene1 <- data.frame(select(filter(tabela,simbol %in% (input$ime1) & datum >= input$datum1[1] & datum <= input$datum1[2]),cena))
        zacetna1 <- zacetna1[,1]
        zacetna2 <- zacetna2[,1]
        cene <- cene[,1]
        cene1 <- cene1[,1]
        cene <- cene/zacetna1
        cene1 <- cene1/zacetna2
        tip = "l"
      }
    }
    plot(datumi[,1],cene,tip,col="red",main=paste("Relativizirane cene",input$select1,"in",input$ime1),xlab="",ylab="",
         ylim=range(min(cene,cene1),max(cene,cene1)))
    lines(datumi[,1],cene1,ylim=range(min(cene,cene1),max(cene,cene1)),xlab="",ylab="",col="green")
    if (tip =="l") {
      abline(h=1,lty=3)
      legend("topleft",legend=c(input$select1,input$ime1),col=c("red","green"),lty=c(1,1))
    }
    if (tip == "n") {
      text(0, (cene+cene1)/2, "Na ta dan ni podatkov!", cex = 2.5, col = "red")
    }
  })
  
  output$datum <- renderUI({
    datumMAX <- data.frame(summarize(select(tabela,datum),max(datum)))
    datumMIN <- data.frame(summarize(select(tabela,datum),min(datum)))
    dateRangeInput("datum",label="Izberi interval za primerjavo:",start=as.Date(datumMIN[1,1])+1,
                   end=as.Date(datumMAX[1,1])+1,language="sl", separator = "do", weekstart = 1)
  })
  
  output$opozorilo <- renderUI({
    datumMIN <- data.frame(summarize(select(tabela,datum),min(datum)))
    helpText(h6(paste("*Opozorilo: Izberi datum od", datumMIN[1,1], "naprej"),col = "#FF0000" ,align = "center"))
  })
  
  output$datum1 <- renderUI({
    datumMAX <- data.frame(summarize(select(tabela,datum),max(datum)))
    datumMIN <- data.frame(summarize(select(tabela,datum),min(datum)))
    dateRangeInput("datum1",label="Izberi interval za primerjavo:",start=as.Date(datumMIN[1,1])+1,
                   end=as.Date(datumMAX[1,1])+1,language="sl", separator = "do", weekstart = 1)
  })
  
  output$opozorilo1 <- renderUI({
    datumMIN <- data.frame(summarize(select(tabela,datum),min(datum)))
    helpText(h6(paste("*Opozorilo: Izberi datum od", datumMIN[1,1], "naprej"),col = "#FF0000" ,align = "center"))
  })
  
  
  output$sharp <- renderTable({
    if (is.null(input$endatum)) {
      t <- data.frame()
    } else {
      t <- data.frame(select(arrange(filter(skupnaTabela, datum == input$endatum),desc(sharp)),c(simbol,ime,sharp,cena)))
    }
    head(t,input$koliko)
  })

  output$backdatum <- renderUI({
    datumMIN <- data.frame(summarize(select(tabela,datum),min(datum)))
    datumMAX <- as.Date(datumMIN[1,1]) + 5
    dateRangeInput("backdatum",label="Izberi interval za primerjavo:",start=as.Date(datumMIN[1,1])+1,
                   end=as.Date(datumMAX)+1,language="sl", separator = "do", weekstart = 1)
  })
  
  output$premozenje <- renderPlot({
    if(is.null(input$backdatum[1])){
      tip <- "n"
    }else{
      zacetni_datum <- as.Date(input$backdatum[1])
      koncni_datum <- as.Date(input$backdatum[2])
      gspc <- data.frame(select(filter(tabela,simbol == "GSPC", datum >= zacetni_datum, datum <= koncni_datum),cena))
      relativ <- gspc[1,1]
      benchmark <- gspc[,1]/relativ
      datumi <- data.frame(select(filter(tabela,simbol == "AAPL", datum >= zacetni_datum,datum <= koncni_datum),datum))
      premozenje <- rep(0,(nrow(datumi)-1))
      for (i in 1:(nrow(datumi)-1)){
        donosi_delnic <- c()
        t <- data.frame(select(arrange(filter(tabela, datum == datumi[i,1]),desc(sharp)),simbol))
        delnice <- head(t,input$st_delnic)
        simboli <- delnice[,1]
        for (j in 1:length(simboli)){
          d <- data.frame(select(filter(tabela,datum == datumi[i+1,1] && simbol == simboli[j]),sprememba))
          donosi_delnic <-append(donosi_delnic,d[1,1])
        }
        donos_portfelja <- mean(donosi_delnic)
        premozenje[i+1] <- donos_portfelja
      }
      premozenje <- premozenje[-1]
      rast_premozenja <- premozenje
      for (i in 1:(length(premozenje)-1)) {
        rast_premozenja[i+1] <- rast_premozenja[i]*premozenje[i+1]
      }
      xos <- datumi[,1]
      xos <- xos[-1]
      benchmark <- benchmark[1:length(benchmark)-1]
      tip <-"r"
    }
    if(tip == "r"){
      plot(xos, rast_premozenja, type = "l",main="Donos",xlab="",ylab="donos",
           ylim=c(min(benchmark,rast_premozenja),max(benchmark,rast_premozenja)))
      lines(xos,benchmark, col = "red")
      abline(h=1,lty=3)
      legend("topleft",legend=c("portfelj","benchmark"),col=c("black","red"),lty=c(1,1))
    }
    if (tip == "n") {
      text(0, 0, "Na ta dan ni podatkov!", cex = 2.5, col = "red")
    }
  })
  
})