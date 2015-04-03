import sys
import urllib.request
import csv
URL = "https://github.com/zangrjol/Optimizacija-donosnosti-portfelja/blob/master/deset.csv"
www = urllib.request.urlopen(URL)
raz = csv.reader([v.decode() for v in www])
##for i in raz:
##    print(i)
