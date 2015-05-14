# Optimizacija-donosnosti-portfelja
Projekt pri OPB

1-podatki
	1-tabela_delnic.R
		1. z getwd() preveri ali si v mapi 1-podatki. Sicer spremeni working directory, kjer se nahaja 1-tabela_delnic.R
		2. Poženi program (v mapi se ustvari podjetja_podatki.csv)
	2-uvoz_podatkov.R 
		1. z getwd() preveri ali si v mapi 1-podatki. Sicer spremeni working directory, kjer se nahaja 2-uvoz_podatkov.R
		2. v tretji vrstici nastavi datum na željeni zaèetek. Opozorilo: Sharpove vrednosti se za prvih 30 dni ne izraèuna
		3. poženi program (v mapi se ustvari podatki_cen.csv)
	3-generiranje_tabel.R 
		1. z getwd() preveri ali si v mapi 1-podatki. Sicer spremeni working directory, kjer se nahaja 3-generiranje_tabel.R
		(2. kasneje bo  možno nastaviti, na koliko dni trgujemo).
		3. Poženemo program. V mapi se ustvarijo tabela1_cene.csv, tabela2_spremembe.csv, tabela3_sharpe.csv

2-baza
	***OPOZORILO***: v mapo prilepi auth.template, ki ga dobiš v mapi auth ter ga preimenuj v auth.py
	V auth.py spremeni db:'seminarska_[username]', host: 'baza.fmf.uni-lj.si', user = '[username]', password = '[password]' in datoteko shrani
	
	4-generiranje_baze_Postgresql.py
		1. Poženi program. 
		2. V konzolo vpiši naslednje ukaze: izbrisiTabele(), ustvariTabele(), uvoziPodatke().
			Opomba: èe tabela še ni definirana, potem izpusti ukaz izbrisiTabele() 


3-shiny
	***OPOZORILO***: v mapo prilepi auth.template, ki ga dobiš v mapi auth ter ga preimenuj v auth.R
	V auth.R spremeni db:'seminarska_[username]', host: 'baza.fmf.uni-lj.si', user = '[username]', password = '[password]' in datoteko shrani
	
	ui.R
		1. nastavi datum start v 18. in 27. vrstici na tisti, od je izbran v 2-uvoz_podatkov.R (upošptevaj 30 dnevno zakasnitev)

	server.R
		1. Poženi program (source)
		2. nastavi working directory na mapo, ki vsebuje 3-shiny (npr. setwd('U:/opb/ODP') )
		3. V konzoli poženi ukaza runApp('3-shiny')

V Shinyu lahko:
	1. izberi datum, na katerega želiš izpisati Sharpove vrednosti. S kolešèkom nastavi, koliko delnic z najboljšimi Sharpovimi vrednosti v padajoèem vrstnem redu želiš prikazati.
	2. Izberi dve razlièni delnici, ki jih želiš primerjati v izbranem èasovnem intervalu. Opozorilo: datume lahko izbereš samo ob trgovalnih dnevih ter v obdobju, ki smo ga izbrali za prikaz gibanja cen delnic.		
