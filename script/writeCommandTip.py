#coding:utf8
import MySQLdb
import json
con = MySQLdb.connect(host='localhost', user='root', passwd='badperson3', db='Wan2', charset='utf8')
sql = 'select * from allTasks'
con.query(sql)
res = con.store_result().fetch_row(0, 1)
for i in res:
    commandList = json.loads(i['commandList'])
    for c in commandList:
        if c.get('tip') != None:
            #sql = "insert into Strings(`key`, `chinese`) values ('%s', '%s') on duplicate key update chinese='%s' "  % ('taskTip'+str(c['msgId']), c['tip'].encode('utf8'), c['tip'].encode('utf8'))
            sql = "insert ignore into Strings(`key`, `chinese`) values ('%s', '%s') "  % ('taskTip'+str(c['msgId']), c['tip'].encode('utf8'))
            print sql
            con.query(sql)

con.commit()
