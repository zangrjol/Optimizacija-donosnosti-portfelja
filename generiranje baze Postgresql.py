#Program, ki generira bazo na Postgresu

import sqlite3        # Knjižnica za delo z bazo
import csv            # Knjižnica za delo s CSV datotekami
import urllib.request # Knjižnica za delo s spletom
import psycopg2, psycopg2.extensions, psycopg2.extras
psycopg2.extensions.register_type(psycopg2.extensions.UNICODE)
import auth

URL = "https://raw.githubusercontent.com/zangrjol/Optimizacija-donosnosti-portfelja/master/proba.csv"
www = urllib.request.urlopen(URL)
delnice = www.readline()
razpredelnica = csv.reader([v.decode() for v in www], delimiter=';')
#BAZA = "baza.psycopg2"
#URL = "https://raw.githubusercontent.com/zangrjol/Optimizacija-donosnosti-portfelja/master/proba.csv"




# Naredimo povezavo z bazo. Funkcija sqlite3.connect vrne objekt,
# ki hrani podatke o povezavi z bazo.
baza = psycopg2.connect(database=auth.db, host=auth.host, user=auth.user, password=auth.password)

#Naredimo tabelo kraj, če je še ni
def izbrisi():
    c = baza.cursor()
    c.execute('DROP TABLE Delnice')
    baza.commit()

def ustvariTabelo():
    c.execute('''CREATE TABLE delnice (
      id SERIAL PRIMARY KEY,
      simbol TEXT,
      datum DATE,
      cena REAL,
      sprememba REAL,
      sharp REAL,
      UNIQUE (Simbol,Datum)
      )''')
    baza.commit()

def ustvariImena():
    c.execute('''CREATE TABLE imena (
      id SERIAL PRIMARY KEY,
      simbol TEXT REFERENCES delnice(simbol),
      ime TEXT
      )''')
    baza.commit()

delnice1 = delnice.decode("utf-8")
delnice2 = delnice1.replace('\n','')

seznam = delnice2.split(sep=";")
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
            
def podatkiCene():
    c = baza.cursor()
    for vrstica in razpredelnica:
        for i in range(1,len(vrstica)):
            c.execute("INSERT INTO delnice(simbol,datum,cena,sprememba,sharp) VALUES (%s,%s,%s,NULL,NULL)", [imena_podjetij[i-1],vrstica[0],float(vrstica[i].replace(',', '.'))] )
    c.close()
    baza.commit()

def podatkiIMena():
    #uvozimo imena delnic v tabelo:
    pot = "C:/Users/MATIC/Desktop/sola/3.letnik/osnove podatkovnih baz/ODP/DJIA.csv"
    csvfile = open(pot,'r')
    naslov = csvfile.readline()
    csv = csv.reader(csvfile, delimiter=";")
    c = baza.cursor()
    for vrstica in csv:
        c.execute("INSERT INTO imena(simbol,ime) VALUES (%s,%s)",[vrstica[1],[vrstica[3]])
    c.close()
    baza.commit()
    csvfile.close()
                                                                  
##for vrstica in razpredelnica:
##        print(vrstica.split(sep=";")
##
##float(s.replace(',', '.'))
              
