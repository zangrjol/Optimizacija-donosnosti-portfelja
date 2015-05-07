library(shiny)
tabela <- read.csv2("DJIA.csv",header=TRUE,fileEncoding="Windows-1250")
imena <- tabela$Symbol
imena <- levels(imena)
shinyUI(fluidPage(
  
  titlePanel("Delnice"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("select",label="Izberi delnico",choices=imena,selected = "AAPL"),
#       
#       dateRangeInput("datum",label=h3("Vnesi datum"),start="2014-01-02",end="2014-12-31",language="sl"),
#       sliderInput("stevilo",label = h3("Minimalna cena"),min=10,max=150,value=10),
#       helpText("Primerjaj z"),
#       textInput("ime2",
#                 "Simbol:",
#                 value = "AAPL"),
      selectInput("ime", label = "Izberi delnico za primerjavo",
                  choices = imena,selected="AXP"),
      dateInput("endatum", label ="Izberi datum",value="2015-05-05"),
      sliderInput("koliko",label="Koliko delnic",min=1,max=30,value=5)
    ),
    
    mainPanel(
      fluidRow(
        column(3,textOutput("naslov"),
               tableOutput("sharp")),
        column(9,
               plotOutput("graf"))
#         column(3,
#                tableOutput("date"))
#         column(3,
#                tableOutput("delnice2"))
      )
    )
  )
))