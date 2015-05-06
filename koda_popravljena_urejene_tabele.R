start.time <- Sys.time()
delnice <- read.csv2(file="C:/zan/faks/opb/ODP/tabela_delnic.csv", header = TRUE, fileEncoding = "Windows-1250")
rownames(delnice)<- delnice[,1]
delnice[,1] <- NULL

######benchmark mora biti na zadnjem mestu pri vnašanju tickerjev!!!!

#vse NA-je nadomestim z 0 (problem bo, če kje vmes NA, sepravi da ob določenem datumu ne bo podatka - 
#UPAM DA TO NI MOŽNO!!! - DRUGAČE TREBA NAREDITI ŠE ENO ZANKO KI JE POMOJE DOST ZAJEBANA) - V DRUGI R KODI JE NAREJENA ZANKA DELNO
delnice[is.na(delnice)] <- 0

#spremenim datum v tri stolpce z letom, mesecem in dnevom
delnice <- cbind(dan = substr(row.names(delnice), 9, 10), delnice)
delnice <- cbind(mesec = substr(row.names(delnice), 6, 7), delnice)
delnice <- cbind(leto = substr(row.names(delnice), 1, 4), delnice)
#delnice <- cbind(indeks = c(1:length(delnice[,1])), delnice)

#zbriše prvo vrstico, kjer so bili prej datumi so zdaj rownames kar indeksi
rownames(delnice) <- c(1:length(delnice[,1]))

cene <- delnice

#i vrstica, j stolpec - vse damo na procentualne spremembe


for (j in 4:((length(delnice[1,])))) { #4, ker imamo še stolpec leto, mesec, dan
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

#write.csv2(delnice,file="C:/zan/faks/opb/ODP/delnice.csv") #tabela s procentualnimi spremambami kotiranja delnic

######################################################################################################
#v novi razpredelnici sharp bomo računasli 90 dnevne sharpove indekse
dnevi <- 90 #koliko dnevni sharpov index računamo



sharp <- delnice
for (j in 4:(length(delnice[1,])-1)) { #do -1, ker zadnji stolpec je benchmark!
  k <- 1
  while (delnice[k,j] == 0) { #začnemo pri tistem k-ju, ko delnica začne kotirati na borzi
    k <- k+1
  }
  for (i in (k+dnevi):length(delnice[,1])) {
    sharp[i,j] <- mean(delnice[(i-(dnevi-1)):i,j]-delnice[(i-(dnevi-1)):i,length(delnice[1,])])/sd(delnice[(i-(dnevi-1)):i,j]-delnice[(i-(dnevi-1)):i,length(delnice[1,])]) #length(delnice[1,]), ker zadnji stolpec je benchmark
  }
  for (i in 1:(k+dnevi-1)) {sharp[i,j] <- NA}
}
sharp <- sharp[(dnevi+1):length(sharp[,1]),] #zbrišem prvih 90 vrstic, kjer sharpov ni izračunan



#write.csv2(sharp,file="C:/zan/faks/opb/ODP/sharp.csv") #tabela izračunanih sharpovih vrednosti

####################################################################################################
#dodajam še novo razpredelnico, ki bo povedala, v katero delnico investirati na vsakih n dni
#vsak n-ti dan bomo pogledali za n dni nazaj, kakšno je bilo povprečje sharpovih svrednosti in izbrali najvišje

n <- 20
delez <- seq(1/n,1, 1/n) #da bomo vzeli tehtano povprečje sharpov z večjo težo na čim kasnejših sharpih
invest <- sharp
invest[is.na(invest)] <- 0
for (j in 4:(length(sharp[1,])-1)) { #do -1, ker zadnji stolpec je benchmark!
  k <- 1
  while (invest[k,j] == 0) { #začnemo pri tistem k-ju, ko delnica začne kotirati na borzi
    k <- k+1
  }
  for (i in (k+n):length(sharp[,1])) {
    invest[i,j] <- mean(sharp[(i-(n-1)):i,j]*delez)
  }
  for (i in 1:(k+n-1)) {invest[i,j] <- NA}
}
invest <- invest[(n+1):length(invest[,1]),] #izbrišem prvih n vrstic, kjer ni izračuna

#write.csv2(invest,file="C:/zan/faks/opb/ODP/invest.csv") #tabela povprečnih sharpovih vrednosti desetih prejšnjih dni

#prikažem samo tiste sharpove, pri katerih trejdam
trade <- invest[seq(1, length(invest[,1]), n), ]
trade[is.na(trade)] <- -Inf #tiste, ki še ne kotirajo, sem dal na -inf, da jih prikaže na zadnjem mestu po velikosti sharpa
trade <- trade[,-length(trade[1,])] #izbrišem benchmark
imena <- trade
#razpredelnica, kam naj investiram v določenih datumih
for (i in 1:length(trade[,1])) {
  trade[i,4:length(trade[1,])] <- ((sort(trade[i,4:length(trade[1,])]))) #razvrstimo jih po velikosti sharpove
}

#indeksi column namesov
y <- c()
for (i in 1:length(trade[,1])) {
  y <- rbind(y,match(trade[i,1:length(trade[1,])], imena[i,1:length(trade[1,])]))
}
y <- y[,-(1:3)]
#vektor column namesov
vektor <- c((colnames(imena)))
#zamenjamo številke za column namese
for (j in 1:length(y[1,])) {
  for (i in 1:length(y[,1])) {
    y[i,j] <- vektor[as.numeric(y[i,j])]
  }
}
#pripnemo še datume in dobimo končno tabelo
koncna <- trade[,-(4:length(trade[1,]))]
koncna <- cbind(koncna,y)

colnames(koncna) <- c("leto", "mesec", "dan", seq(length(trade[1,])-3, 1, -1))
koncna <- koncna[,c(1,2,3,length(koncna[1,]):4)] #tak vrstni red, kot hočem - 1 pomeni največji sharpov

#write.csv2(trade,file="C:/zan/faks/opb/ODP/trade.csv") #tabela delnic, ki padajo po sharpovih vrednostih

#lahko bi še pogledal, kakšne standardne odklone imajo sharpove in ali je trend naraščanja/padanja...
#plot(rownames(sharp), sharp[,8], type="l")



#profit, če investiramo vsako obdobje v 5 delnic z najvišjim sharpom
# proba <- (koncna[-(1:3)])
# proba <- proba[-(6:length(proba[1,]))] #investiramo v 5 delnic
# profit <- 1
# profit.skupen <- 0
# for (j in 1:length(proba[1,])) {
#   profit.skupen <- profit.skupen + profit
#   for (i in 1:(length(proba[,1])-1)) {
#     profit <- profit * (((cene[dnevi+n+1+n*(i),proba[i,j]]-cene[dnevi+n+1+n*(i-1),proba[i,j]])/cene[dnevi+n+1+n*(i-1),proba[i,j]])+1)
#   }
# }
# 
# #profiti vsake strategije posebej (profit(i) označuje profit, če investiramo v i-to sharpovo največjo delnico)
# profit1 <- 1
# profit2 <- 1
# profit3 <- 1
# profit4 <- 1
# profit5 <- 1
# for (i in 1:(length(proba[,1])-1)) {
#   profit1 <- profit1 * (((cene[dnevi+n+1+n*(i),proba[i,1]]-cene[dnevi+n+1+n*(i-1),proba[i,1]])/cene[dnevi+n+1+n*(i-1),proba[i,1]])+1)
# }
# for (i in 1:(length(proba[,1])-1)) {
#   profit2 <- profit2 * (((cene[dnevi+n+1+n*(i),proba[i,2]]-cene[dnevi+n+1+n*(i-1),proba[i,2]])/cene[dnevi+n+1+n*(i-1),proba[i,2]])+1)
# }
# for (i in 1:(length(proba[,1])-1)) {
#   profit3 <- profit3 * (((cene[dnevi+n+1+n*(i),proba[i,3]]-cene[dnevi+n+1+n*(i-1),proba[i,3]])/cene[dnevi+n+1+n*(i-1),proba[i,3]])+1)
# }
# for (i in 1:(length(proba[,1])-1)) {
#   profit4<- profit4 *(((cene[dnevi+n+1+n*(i),proba[i,4]]-cene[dnevi+n+1+n*(i-1),proba[i,4]])/cene[dnevi+n+1+n*(i-1),proba[i,4]])+1)
# }
# for (i in 1:(length(proba[,1])-1)) {
#   profit5 <- profit5 * (((cene[dnevi+n+1+n*(i),proba[i,5]]-cene[dnevi+n+1+n*(i-1),proba[i,5]])/cene[dnevi+n+1+n*(i-1),proba[i,5]])+1)
# }
# 
# profit.skupen-1
# profit1-1
# profit2-1
# profit3-1
# profit4-1
# profit5-1



end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken