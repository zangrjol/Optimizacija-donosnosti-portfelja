library(XML)
theurl <- "http://en.wikipedia.org/wiki/Dow_Jones_Industrial_Average"
tables <- readHTMLTable(theurl)
t <- tables[[2]]

write.table(t,file="C:/Users/MATIC/Desktop/sola/3.letnik/osnove podatkovnih baz/ODP/podjetja_podatki.csv",sep=";")
