import sys
import urllib.request
import csv
##URL = "https://github.com/zangrjol/Optimizacija-donosnosti-portfelja/blob/master/deset.csv"
##www = urllib.request.urlopen(URL)
##raz = csv.reader([v.decode() for v in www])
####for i in raz:
####    print(i)

##mat = [1,2,"m","b",4]
##for i in enumerate(mat):
##    print(mat[i[0]])

url = "https://raw.githubusercontent.com/zangrjol/Optimizacija-donosnosti-portfelja/master/deset.csv"
www = urllib.request.urlopen(url)
raz = csv.reader([v.decode() for v in www])
print(raz)
vrs = www.readline()
if vrs == b'':
    print("ja")
else:
    print("ne")
##for i in raz:
##    print(i)


