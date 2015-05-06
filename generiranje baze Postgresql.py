#Program, ki generira bazo na Postgresu

import sqlite3        # Knjižnica za delo z bazo
import csv            # Knjižnica za delo s CSV datotekami
import urllib.request # Knjižnica za delo s spletom
import psycopg2, psycopg2.extensions, psycopg2.extras
psycopg2.extensions.register_type(psycopg2.extensions.UNICODE)
import auth

#URL naslovi:
URL = "https://raw.githubusercontent.com/zangrjol/Optimizacija-donosnosti-portfelja/master/proba.csv"
#URL1 =
#URL2 =
#URL3 =

#urejanje tabel pridobljenih iz URL naslovov:
wwwcene = urllib.request.urlopen(URL)
delnice = wwwcene.readline()
razpredelnica = csv.reader([v.decode() for v in wwwcene], delimiter=';')

##wwwsp = urllib.request.urlopen(URL1)
##sprememba = wwwsp.readline()
##spremembe = csv.reader([v.decode() for v in wwwsp], delimiter=';')

##wwwsharp = urllib.request.urlopen(URL2)
##sharp = wwwsharp.readline()
##sharpove = csv.reader([v.decode() for v in wwwsharp], delimiter=';')
####
##www3 = urllib.request.urlopen(URL3)
##sharp5 = www3.readline()
##www4 = urllib.request.urlopen(URL4)
##sharp20 = www4.readline()
##www5 = urllib.request.urlopen(URL5)
##sharp126 = www5.readline()
##sharpove = csv.reader([v.decode() for v in www2], delimiter=';')


# Naredimo povezavo z bazo. Na Postgresql
baza = psycopg2.connect(database=auth.db, host=auth.host, user=auth.user, password=auth.password)

#najprej izbrisemo tabelo, ce je slucajno ze ustvarjena:
def izbrisi():
    c = baza.cursor()
    c.execute('DROP TABLE delnice')
    baza.commit()


#ko ni na postgresql-u nobene tabele!! ustvarimo tabeli:
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
#####

#uredimo podatke, kodiranje in izbrisemo prazne znake
delnice1 = delnice.decode("utf-8")
delnice2 = delnice1.replace('\n','')

####
#sprememba1 = sprememba.decode("utf-8")
#sprememba2 = sprememba1.replace('\n','')
#sharp1 = sharp.decode("utf-8")
#sharp2 = sharp.replace('\n','')

#sharp5 = sharp.decode("utf-8")
#sharp51 = sharp.replace('\n','')
#sharp20 = sharp.decode("utf-8")
#sharp201 = sharp.replace('\n','')
#sharp126 = sharp.decode("utf-8")
#sharp1261 = sharp.replace('\n','')

#preverimo katera imena imamo in jih spravimo v seznam
seznam = delnice2.split(sep=";")
imena_podjetij = seznam[1:]


#funkcija, ki nam
def iskanje(datoteka):
    www = urllib.request.urlopen(URL)
    delnice = www.readline()
    razpredelnica = csv.reader([v.decode() for v in www])
    for vrstica in razpredelnica:
        for i in len(vrstica):
            print(i)

#funkcija, ki nam uvozi podatke o cenah           
def podatkiCene():
    c = baza.cursor()
    for vrstica in razpredelnica:
        for i in range(1,len(vrstica)):
            c.execute("INSERT INTO delnice(simbol,datum,cena) VALUES (%s,%s,%s)", [imena_podjetij[i-1],vrstica[0],float(vrstica[i].replace(',', '.'))] )
    c.close()
    baza.commit()

#funkcija, ki nam uvozi podatke o spremembah
def podatkiSpremembe():
    c = baza.cursor()
    for vrstica in spremembe:
        for i in range(1,len(vrstica)):
            c.execute("INSERT INTO delnice(sprememba) VALUES (%s)",[float(vrstica[i].replace(',','.'))])
    c.close()
    baza.commit()

#funkcija, ki nam uvozi podatke o spremembah
def podatkiSharp():
    c = baza.cursor()
    for vrstica in sharpove:
        for i in range(1,len(vrstica)):
            c.execute("INSERT INTO delnice(sharp) VALUES (%s)",[float(vrstica[i].replace(',','.'))])
    c.close()
    baza.commit()

##def podatkiIMena():
##    #uvozimo imena delnic v tabelo:
##    pot = "C:/Users/MATIC/Desktop/sola/3.letnik/osnove podatkovnih baz/ODP/DJIA.csv"
##    csvfile = open(pot,'r')
##    naslov = csvfile.readline()
##    csv = csv.reader(csvfile, delimiter=";")
##    c = baza.cursor()
##    for vrstica in csv:
##        c.execute("INSERT INTO imena(simbol,ime) VALUES (%s,%s)",[vrstica[1],[vrstica[3]])
##    c.close()
##    baza.commit()
##    csvfile.close()
                                                                  
##for vrstica in razpredelnica:
##        print(vrstica.split(sep=";")
##
##float(s.replace(',', '.'))
              
