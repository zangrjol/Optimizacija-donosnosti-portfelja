import sys
import urllib.request
import csv
import sqlite3
##URL = "https://github.com/zangrjol/Optimizacija-donosnosti-portfelja/blob/master/deset.csv"
##www = urllib.request.urlopen(URL)
##raz = csv.reader([v.decode() for v in www])
####for i in raz:
####    print(i)

##mat = [1,2,"m","b",4]
##for i in enumerate(mat):
##    print(mat[i[0]])

BAZA = "delnice.db"
baza = sqlite3.connect(BAZA)
baza.execute('''CREATE TABLE IF NOT EXISTS Delnica (
    OPK REAL,
    AVT REAL,
    GPN REAL,
    SDRL REAL,
    LEK REAL,
    ITC REAL,
    TEG REAL,
    IIX REAL,
    CSGP REAL,
    CSL REAL
)''')
url = "https://raw.githubusercontent.com/zangrjol/Optimizacija-donosnosti-portfelja/master/deset1.csv"
www = urllib.request.urlopen(url)
#raz = csv.reader([v.decode() for v in www])
vrs = www.readline()


def vrednost(s):
    return float(s)
razpredelnica = csv.reader([v.decode() for v in www])

for vrstica in razpredelnica:
    #print(type(vrstica))
    OPK = vrednost(vrstica[1])
    AVT = vrednost(vrstica[2])
    GPN = vrednost(vrstica[3])
    SDRL = vrednost(vrstica[4])
    LEG = vrednost(vrstica[5])
    ITC = vrednost(vrstica[6])
    TEG = vrednost(vrstica[7])
    IEX = vrednost(vrstica[8])
    CSGP = vrednost(vrstica[9])
    CSL = vrednost(vrstica[10])
    # Dodamo delnico, če je še ni
##    c = baza.cursor()
##    c.execute('SELECT 1 FROM Delnica WHERE OPK=?', [OPK])
##    if list(c) == []:
##        print ('NOVA DELNICA: {0}, {1}'.format(symbol, name))
##        baza.execute("""INSERT INTO delnica VALUES (?,?)""", (symbol,name))
##    c.close()
    # Vstavimo vrstico v promet
    # POTREBNA IZBOLJSAVA: vrstice ne dodamo, če ta zapis že imamo
##    print ("Vstavljam {0}".format(symbol))
    baza.execute("""INSERT INTO Delnica VALUES (?,?,?,?,?,?,?,?,?,?)""",
                 (OPK,AVT,GPN,SDRL,LEG,ITC,TEG,IEX,CSGP,CSL))

baza.commit()

##if vrs == b'':
##    print("ja")
##else:
##    print("ne")
##for i in raz:
##    print(i)


##datoteka = "kozuh.txt"
##f = open(datoteka,'r')
##vrs = f.readline()
##vrs2 = f.readline()

##datoteka = "deset1.csv"
##f = open(datoteka, 'r')
##vrs = f.readline()
##vrs2 = f.readline()
