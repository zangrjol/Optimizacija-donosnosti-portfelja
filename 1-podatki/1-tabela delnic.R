library(XML)
theurl <- "http://en.wikipedia.org/wiki/Dow_Jones_Industrial_Average"
tables <- readHTMLTable(theurl)
t <- tables[[2]]

write.table(t,file="podjetja_podatki.csv",sep=";")
