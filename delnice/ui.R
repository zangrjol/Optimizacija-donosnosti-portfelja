library(shiny)
tabela <- read.csv2("DJIA.csv",header=TRUE,fileEncoding="Windows-1250")
imena <- tabela$Symbol
imena <- levels(imena)
shinyUI(fluidPage(
  
  titlePanel("Delnice"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("select",label="Izberi delnico",choices=imena,selected = "AAPL"),
      selectInput("ime", label = "Izberi delnico za primerjavo",
                  choices = imena,selected="AXP"),
      dateRangeInput("datum",label=h3("Izberi interval za primerjavo:"),start="2014-02-14",
                     end="2014-12-31",language="sl", separator = "do", weekstart = 1, format = "dd.mm.yyyy"),
#       sliderInput("stevilo",label = h3("Minimalna cena"),min=10,max=150,value=10),
#       helpText("Primerjaj z"),
#       textInput("ime2",
#                 "Simbol:",
#                 value = "AAPL"),
      dateInput("endatum", label ="Izberi datum za izpis Sharpovih vrednosti:",value="2015-05-05"),
      sliderInput("koliko",label="Najboljsih koliko?",min=1,max=30,value=5)
    ),
    
    mainPanel(
      fluidRow(
        column(3,h3(textOutput("naslov")),
               tableOutput("sharp")),
        column(9,
               plotOutput("graf"),
               plotOutput("graf2"))
#         column(3,
#                tableOutput("date"))
#         column(3,
#                tableOutput("delnice2"))
      )
    )
  )
))