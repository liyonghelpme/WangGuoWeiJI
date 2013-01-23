#coding:utf8
import time
import MySQLdb
import codecs

myCon = MySQLdb.connect(host='localhost', user='root', passwd='badperson3', db='Wan2', charset='utf8')

sql = 'select * from Strings'
myCon.query(sql)
rows = myCon.store_result().fetch_row(0, 1)
f = codecs.open('../data/words.as', 'w', 'utf8')
f.write('var WORDS = dict([\n')
for i in rows:
    v = i['chinese'].replace('\n', '\\n')
    e = i['english'].replace('\n', '\\n')
    f.write('["%s", ["%s", "%s"]],\n' % (i['key'], v, e))

f.write(']);')
f.close()
    
