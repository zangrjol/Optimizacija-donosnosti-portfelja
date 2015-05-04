library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Delnice"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("ime",
                "Simbol:",
                value = "ci"),
      
      dateRangeInput("datum",label=h3("Vnesi datum"),start="2014-01-02",end="2014-12-31",language="sl"),
      sliderInput("stevilo",label = h3("Minimalna cena"),min=10,max=150,value=10),
      helpText("Primerjaj z"),
      textInput("ime2",
                "Simbol:",
                value = "unh")   
    ),
    
    mainPanel(
      fluidRow(
        column(3,
               tableOutput("delnice")),
        column(3,
               tableOutput("date")),
        column(3,
               tableOutput("delnice2"))
      )
    )
  )
))