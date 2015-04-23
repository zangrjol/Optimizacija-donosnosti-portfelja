import sqlite3        # Knjižnica za delo z bazo
import csv            # Knjižnica za delo s CSV datotekami
import urllib.request # Knjižnica za delo s spletom

BAZA = "baza.sqlite3"
URL = "https://raw.githubusercontent.com/zangrjol/Optimizacija-donosnosti-portfelja/master/proba.csv"

# Naredimo povezavo z bazo. Funkcija sqlite3.connect vrne objekt,
# ki hrani podatke o povezavi z bazo.
baza = sqlite3.connect(BAZA)

# Naredimo tabelo kraj, če je še ni
baza.execute('''CREATE TABLE IF NOT EXISTS Delnice (
  Simbol TEXT,
  Datum TEXT,
  Cena REAL,
  )''')

def importData():
    #print("Berem %s ..." % URL)
    www = urllib.request.urlopen(URL)

    delnice = www.readline()
    razpredelnica = csv.reader([v.decode() for v in www])
    
