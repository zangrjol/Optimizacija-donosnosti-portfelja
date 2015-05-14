library(quantmod)
tabela <- read.csv2("podjetja_podatki.csv",header=TRUE,fileEncoding="Windows-1250")
imena <- tabela$Symbol
imena <- levels(imena)
imena <- append(imena,"GSPC")
# zaUvoz <- c()
# for(i in 1:length(imena)){
#   zaUvoz[i] <- paste(imena[i],"$",imena[i],".Adjusted",sep="")}
datum <- "2013-11-17" #od 2013-11-15 potem pride na 31.12.1014
getSymbols(imena,from=datum)
#spremeni imena tickerjev (dobiš jih v Excelu podjetja_podatki.csv)
skupaj <- cbind(AAPL[,6],AXP[,6],BA[,6],CAT[,6],CSCO[,6],CVX[,6],DD[,6],DIS[,6],GE[,6],
                GS[,6],HD[,6],IBM[,6],INTC[,6],JNJ[,6],JPM[,6],KO[,6],MCD[,6],MMM[,6],MRK[,6],
                MSFT[,6],NKE[,6],PFE[,6],PG[,6],TRV[,6],UNH[,6],UTX[,6],V[,6],VZ[,6],WMT[,6],
                XOM[,6],GSPC[,6])
colnames(skupaj) <- imena
sk <- data.frame(skupaj)

write.csv2(sk,file="U:/opb/ODP/podatki_cen.csv",row.names=TRUE)
