#Program, ki generira bazo na Postgresu

import csv            # Knjižnica za delo s CSV datotekami
import urllib.request # Knjižnica za delo s spletom
import psycopg2, psycopg2.extensions, psycopg2.extras
psycopg2.extensions.register_type(psycopg2.extensions.UNICODE)
import auth

#URL naslovi:
URL = "https://raw.githubusercontent.com/zangrjol/Optimizacija-donosnosti-portfelja/master/1-podatki/tabela1_cene.csv"
URL1 = "https://raw.githubusercontent.com/zangrjol/Optimizacija-donosnosti-portfelja/master/1-podatki/tabela2_spremembe.csv"
URL2 = "https://raw.githubusercontent.com/zangrjol/Optimizacija-donosnosti-portfelja/master/1-podatki/tabela3_sharpe.csv"
URL3 = "https://raw.githubusercontent.com/zangrjol/Optimizacija-donosnosti-portfelja/master/1-podatki/podjetja_podatki.csv"

#urejanje tabel pridobljenih iz URL naslovov:
wwwcene = urllib.request.urlopen(URL)
delnice = wwwcene.readline()
razpredelnica = csv.reader([v.decode() for v in wwwcene], delimiter=';')

wwwsp = urllib.request.urlopen(URL1)
sprememba = wwwsp.readline()
spremembe = csv.reader([v.decode() for v in wwwsp], delimiter=';')

wwwsharp = urllib.request.urlopen(URL2)
sharp = wwwsharp.readline()
sharpove = csv.reader([v.decode() for v in wwwsharp], delimiter=';')

wwwimena = urllib.request.urlopen(URL3)
im = wwwimena.readline()
ima = csv.reader([v.decode() for v in wwwimena], delimiter=';')
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
def izbrisiDelnice():
    c = baza.cursor()
    c.execute('DROP TABLE delnice')
    baza.commit()

def izbrisiImena():
    c = baza.cursor()
    c.execute('DROP TABLE imena')
    baza.commit()    


#ko ni na postgresql-u nobene tabele!! ustvarimo tabeli:
def ustvariTabelo():
    c = baza.cursor()
    c.execute('''CREATE TABLE delnice (
      id SERIAL PRIMARY KEY,
      simbol TEXT REFERENCES imena(simbol),
      datum DATE,
      cena REAL,
      sprememba REAL,
      sharp REAL,
      UNIQUE (simbol,datum)
      )''')
    baza.commit()

def ustvariImena():
    c = baza.cursor()
    c.execute('''CREATE TABLE imena (
      id SERIAL PRIMARY KEY,
      simbol TEXT UNIQUE,
      ime TEXT
      )''')
    baza.commit()
#####

#uredimo podatke, kodiranje in izbrisemo prazne znake
delnice1 = delnice.decode("utf-8")
delnice2 = delnice1.replace('\n','')

##sprememba1 = sprememba.decode("utf-8")
##sprememba2 = sprememba1.replace('\n','')
##sharp1 = sharp.decode("utf-8")
##sharp2 = sharp1.replace('\n','')

#sharp5 = sharp.decode("utf-8")
#sharp51 = sharp.replace('\n','')
#sharp20 = sharp.decode("utf-8")
#sharp201 = sharp.replace('\n','')
#sharp126 = sharp.decode("utf-8")
#sharp1261 = sharp.replace('\n','')

#preverimo katera imena imamo in jih spravimo v seznam
seznam = delnice2.split(sep=";")
imena_podjetij = seznam[1:]
imena =[]
for i in imena_podjetij:
    imena.append(i[1:len(i)-1])


#funkcija, ki nam uvozi podatke o cenah           
def podatkiCene():
    c = baza.cursor()
    j = 0  #stevec (nepomemben)
    for vrstica in razpredelnica:
        j +=1
        spr = spremembe.__next__()
        sha = sharpove.__next__()
        print(j)  #samo, da vidimo, da nekaj dela in koliko casa bo se potreboval
        for i in range(1,len(vrstica)):
            c.execute("INSERT INTO delnice(simbol,datum,cena,sprememba,sharp) VALUES (%s,%s,%s,%s,%s)", [imena[i-1],vrstica[0],float(vrstica[i].replace(',', '.')),float(spr[i].replace(',', '.')),float(sha[i].replace(',', '.'))] )
    c.close()
    baza.commit()

#funkcija, ki nam uvozi podatke o spremembah
def podatkiSpremembe():
    c = baza.cursor()
    for vrstica in spremembe:
        for i in range(1,len(vrstica)):
            c.execute("UPDATE delnice SET sprememba= %s",[float(vrstica[i].replace(',','.'))])
    c.close()
    baza.commit()

#funkcija, ki nam uvozi podatke o spremembah
def podatkiSharp():
    c = baza.cursor()
    for vrstica in sharpove:
        for i in range(1,len(vrstica)):
            c.execute("UPDATE delnice SET sharp = %s",[float(vrstica[i].replace(',','.'))])
    c.close()
    baza.commit()

def podatkiImena():
    c = baza.cursor()
    for vrstica in ima:
        c.execute("INSERT INTO imena(ime,simbol) VALUES (%s,%s)",[vrstica[1],vrstica[3]])
    c.execute("INSERT INTO imena(ime,simbol) VALUES ('SP500','GSPC')")
    c.close()
    baza.commit()
                                                                  
##for vrstica in razpredelnica:
##        print(vrstica.split(sep=";")
##
##float(s.replace(',', '.'))
              
def izbrisiTabele():
    try:
        izbrisiDelnice()
    except:
        pass
    try:
        izbrisiImena()
    except:
        pass

def ustvariTabele():
    print("Ustvarjam tabele")
    ustvariImena()
    ustvariTabelo()
    print("Tabele so ustvarjene")

def uvoziPodatke():
    print("Uvažam podatke")
    podatkiImena()
    podatkiCene()
    print("Podatki so uvoženi")


izbrisiTabele()    
ustvariTabele()
uvoziPodatke()

    
