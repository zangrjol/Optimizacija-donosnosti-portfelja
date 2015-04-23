import sqlite3        # Knjižnica za delo z bazo
import csv            # Knjižnica za delo s CSV datotekami
import urllib.request # Knjižnica za delo s spletom

URL = "https://raw.githubusercontent.com/zangrjol/Optimizacija-donosnosti-portfelja/master/proba.csv"
www = urllib.request.urlopen(URL)
delnice = www.readline()
razpredelnica = csv.reader([v.decode() for v in www], delimiter=';')
BAZA = "baza.sqlite3"
#URL = "https://raw.githubusercontent.com/zangrjol/Optimizacija-donosnosti-portfelja/master/proba.csv"

# Naredimo povezavo z bazo. Funkcija sqlite3.connect vrne objekt,
# ki hrani podatke o povezavi z bazo.
baza = sqlite3.connect(BAZA)

# Naredimo tabelo kraj, če je še ni
##baza.execute('''CREATE TABLE IF NOT EXISTS Delnice (
##  Simbol TEXT,
##  Datum TEXT,
##  Cena REAL,
##  )''')

delnice1 = delnice.decode("utf-8")

seznam = delnice1.split(sep=";")
imena_podjetij = seznam[1:]
##def imena_delnic(seznam):
##    for i in seznam[1:]:

def iskanje(datoteka):
    www = urllib.request.urlopen(URL)
    delnice = www.readline()
    razpredelnica = csv.reader([v.decode() for v in www])
    for vrstica in razpredelnica:
        for i in len(vrstica):
            print(i)

#c = baza.cursor()
#c.execute("INSERT INTO Delnice VALUES (?,?,?)", 

#for vrstica in razpredelnica:
#        print(vrstica.split(sep=";")

#float(s.replace(',', '.'))
              
