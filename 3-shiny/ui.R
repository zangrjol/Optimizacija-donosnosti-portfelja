library(shiny)
source("auth-public.R")
conn <- src_postgres(dbname = db, host = host,
                     user = user, password = password)
tabela <- tbl(conn, "imena")
tabela1 <- tbl(conn, "delnice")
skupajTabela <- merge(tabela1,tabela, by ="simbol")
tab <- data.frame(select(arrange(tabela,simbol),simbol))
tabela 
imena <- tab[,1]
shinyUI(fluidPage(
  
  titlePanel("Delnice"),
  
  sidebarLayout(
    sidebarPanel(
      h2("Sharpove vrednosti"),
      uiOutput("endatum"),
      sliderInput("koliko",label="Najboljsih koliko?",min=1,max=30,value=5),
      h2("Primerjava podjetij"),
      selectInput("select",label="Izberi delnico",choices=imena,selected = imena[1]),
      selectInput("ime", label = "Izberi delnico za primerjavo",
                  choices = imena,selected=imena[2]),
      uiOutput("datum"),
      uiOutput("opozorilo")
#       sliderInput("stevilo",label = h3("Minimalna cena"),min=10,max=150,value=10),
#       helpText("Primerjaj z"),
#       textInput("ime2",
#                 "Simbol:",
#                 value = "AAPL")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Sharpove", h3(textOutput("naslov")),tableOutput("sharp")), 
        tabPanel("Primerjava cen", 
                 fluidRow(plotOutput("graf")), 
                 fluidRow(plotOutput("graf1"))),
        tabPanel("Primerjava donosov", plotOutput("graf2"))
      )
    )

#     mainPanel(
#       fluidRow(
#         column(3,h3(textOutput("naslov")),
#                tableOutput("sharp")),
#         column(9,
#                plotOutput("graf"),
#                plotOutput("graf2"))
# #         column(3,
# #                tableOutput("date"))
# #         column(3,
# #                tableOutput("delnice2"))
#       )
#     )
  )
))