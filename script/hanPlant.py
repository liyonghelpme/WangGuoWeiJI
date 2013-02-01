#coding:utf8
import MySQLdb
import json
import csv
con = MySQLdb.connect(host='localhost', user='root', passwd='badperson3', db='Wan2', charset='utf8')
f = csv.reader(open('plantsil.csv'))
f = [i for i in f]
#silver exp time silver exp time 
#silver exp time
id = 0
for i in f:
    for k in xrange(0, 15):
        i[k] = int(i[k])
    sql = 'update plant set gainsilver = %d, exp = %d, time = %d where id = %d' % (i[0], i[1], i[2], id*5)
    con.query(sql)
    sql = 'update plant set gainsilver = %d, exp = %d, time = %d where id = %d' % (i[3], i[4], i[5], id*5+1)
    con.query(sql)
    sql = 'update plant set gainsilver = %d, exp = %d, time = %d where id = %d' % (i[6], i[7], i[8], id*5+2)
    con.query(sql)
    sql = 'update plant set gainsilver = %d, exp = %d, time = %d where id = %d' % (i[9], i[10], i[11], id*5+3)
    con.query(sql)
    sql = 'update plant set gainsilver = %d, exp = %d, time = %d where id = %d' % (i[12], i[13], i[14], id*5+4)
    con.query(sql)
    
    id += 1
con.commit()
con.close()
    
    
