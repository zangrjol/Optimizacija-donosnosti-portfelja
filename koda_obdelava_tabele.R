tickerji <- read.csv2(file="U:/opb/projekt/projekt.csv", header = TRUE, fileEncoding = "Windows-1250")
rownames(tickerji)<- tickerji[,1]
tickerji[,1] <- NULL



#################samo vzorec desetih
#delal bom najrepj na vzorcu desetih tickerjev
#deset <- tickerji[,1:10]

#v tabelo deset dodam še benchmark SP500
#deset$GSPC <- tickerji$GSPC
#################

delnice <- tickerji

#vse NA-je nadomestim z 0 (problem bo, če kje vmes NA, sepravi da ob določenem datumu ne bo podatka - 
#UPAM DA TO NI MOŽNO!!! - DRUGAČE TREBA NAREDITI ŠE ENO ZANKO KI JE POMOJE DOST ZAJEBANA)
# for (i in 1:(length(delnice[1,]))) {
#   as.numeric(delnice[i])
# }
delnice[is.na(delnice)] <- 0

#spremenim datum v tri stolpce z letom, mesecem in dnevom


delnice$leto <- substr(row.names(delnice), 1, 4)
delnice$mesec <- substr(row.names(delnice), 6, 7)
delnice$dan <- substr(row.names(delnice), 9, 10)
# delnice$index <- c(1:length(delnice[,1])) #za vsak slučaj na koncu še en indeks, ker prvi 
#                                           #stolpec so rownames
rownames(delnice) <- c(1:length(delnice[,1]))


#i vrstica, j stolpec - vse damo na procentualne spremembe


for (j in 1:((length(delnice[1,])-3))) { #-3, ker imamo še stolpec leto, mesec, dan
  i <- length(delnice[,1])
  while (i>1 & delnice[i,j] != 0) {
    delnice[i,j] <- delnice[i,j]/delnice[i-1,j]
    i <- i-1
  }
  if (delnice[i,j]==0) {
    delnice[i+1,j] <- 1
  }
  else {delnice[i,j] <- 1}
}

#prva vrstica bo vrstica samih 1
#delnice[1,1:(length(delnice[1,])-3)] <- 1

write.csv2(delnice,file="U:/opb/delnice.csv")
