start.time <- Sys.time()
delnice <- read.csv2(file="U:/opb/ODP/DJIApodatki.csv", header = TRUE, fileEncoding = "Windows-1250")
rownames(delnice)<- delnice[,1]
delnice[,1] <- NULL

######benchmark mora biti na zadnjem mestu pri vnašanju tickerjev!!!!
delnice[is.na(delnice)] <- 0

cene <- delnice

#i vrstica, j stolpec - vse damo na procentualne spremembe


for (j in 1:((length(delnice[1,])))) { 
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
#####################a damo še -1 da dobimo res spremembe procentualne al kr tko pustimo???#######################################


#write.csv2(delnice,file="C:/zan/faks/opb/ODP/delnice.csv") #tabela s procentualnimi spremambami kotiranja delnic

######################################################################################################
#v novi razpredelnici sharp bomo računasli 30 dnevne sharpove indekse
dnevi <- 30 #koliko dnevni sharpov index računamo



sharp <- delnice
for (j in 1:(length(delnice[1,])-1)) { #do -1, ker zadnji stolpec je benchmark!
  k <- 1
  while (delnice[k,j] == 0) { #začnemo pri tistem k-ju, ko delnica začne kotirati na borzi
    k <- k+1
  }
  for (i in (k+dnevi):length(delnice[,1])) {
    sharp[i,j] <- mean(delnice[(i-(dnevi-1)):i,j]-delnice[(i-(dnevi-1)):i,length(delnice[1,])])/sd(delnice[(i-(dnevi-1)):i,j]-delnice[(i-(dnevi-1)):i,length(delnice[1,])]) #length(delnice[1,]), ker zadnji stolpec je benchmark
  }
  for (i in 1:(k+dnevi-1)) {sharp[i,j] <- NA}
}
#sharp <- sharp[(dnevi+1):length(sharp[,1]),] #zbrišem prvih 90 vrstic, kjer sharpov ni izračunan



#write.csv2(sharp,file="C:/zan/faks/opb/ODP/sharp.csv") #tabela izračunanih sharpovih vrednosti

####################################################################################################
#dodajam še novo razpredelnico, ki bo povedala, v katero delnico investirati na vsakih n dni
#vsak n-ti dan bomo pogledali za n dni nazaj, kakšno je bilo povprečje sharpovih svrednosti in izbrali najvišje

n <- 1
delez <- seq(1/n,1, 1/n) #da bomo vzeli tehtano povprečje sharpov z večjo težo na čim kasnejših sharpih
invest <- sharp
invest[is.na(invest)] <- 0
for (j in 1:(length(sharp[1,])-1)) { #do -1, ker zadnji stolpec je benchmark!
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
  trade[i,1:length(trade[1,])] <- ((sort(trade[i,1:length(trade[1,])]))) #razvrstimo jih po velikosti sharpove
}

#indeksi column namesov
y <- c()
for (i in 1:length(trade[,1])) {
  y <- rbind(y,match(trade[i,1:length(trade[1,])], imena[i,1:length(trade[1,])]))
}

#vektor column namesov
vektor <- c((colnames(imena)))
#zamenjamo številke za column namese
for (j in 1:length(y[1,])) {
  for (i in 1:length(y[,1])) {
    y[i,j] <- vektor[as.numeric(y[i,j])]
  }
}
#pripnemo še datume in dobimo končno tabelo
rownames(y)<- rownames(trade)

colnames(y) <- c(seq(length(trade[1,]), 1, -1))
koncna <- y[,c(length(y[1,]):1)] #tak vrstni red, kot hočem - 1 pomeni največji sharpov

#write.csv2(trade,file="C:/zan/faks/opb/ODP/trade.csv") #tabela delnic, ki padajo po sharpovih vrednostih




#uporabili bomo: cene, delnice, sharp
tabela1_cene <- cene[(dnevi+1):length(cene[,1]),]
tabela2_spremembe <- delnice[(dnevi+1):length(delnice[,1]),]
tabela3_sharpe <- sharp[(dnevi+1):length(sharp[,1]),]

#odstranimo še gspc benchmark
tabela1_cene <- tabela1_cene[c(1:length(tabela1_cene)-1)]
tabela2_spremembe <- tabela2_spremembe[c(1:length(tabela2_spremembe)-1)]
tabela3_sharpe <- tabela3_sharpe[c(1:length(tabela3_sharpe)-1)]

#prikažem samo tiste dneve, na katere investiram
tabela1_cene <- tabela1_cene[seq(1, length(tabela1_cene[,1]), n), ]
tabela2_spremembe <- tabela2_spremembe[seq(1, length(tabela2_spremembe[,1]), n), ]
tabela3_sharpe <- tabela3_sharpe[seq(1, length(tabela3_sharpe[,1]), n), ]

#shranimo
# write.csv2(tabela1_cene,file="C:/zan/faks/opb/ODP/tabela1_cene.csv")
# write.csv2(tabela2_spremembe,file="C:/zan/faks/opb/ODP/tabela2_spremembe.csv")
# write.csv2(tabela3_sharpe,file="C:/zan/faks/opb/ODP/tabela3_sharpe.csv")

###################relativizacija cen
krivulja <- cene
for (j in 1:((length(delnice[1,])))) { 
  i <- length(delnice[,1])
  while (i>1 & delnice[i,j] != 0) {
    i <- i-1
  }
  for (k in i:length(delnice[,1])) {
    krivulja[k,j] <- cene[k,j]/cene[i,j]
  }
}
# plot(seq(1,length(delnice[,1]), 1), krivulja$AAPL, type="l")
# lines(krivulja$AXP)
# lines(krivulja$GS)
write.csv2(krivulja,file="U:/opb/ODP/krivulja.csv")

end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken