#coding:utf8
import os
import re
os.system('cp ../fullRes/* ../dbResAndOther')
os.system('cp 技能/* ../dbResAndOther/')
os.system('cp 建筑物/* ../dbResAndOther/')
os.system('cp 建筑物动画/* ../dbResAndOther/')
#药水图片不对
os.system('cp 药品/* ../dbResAndOther/')
os.system('cp 远程攻击技能/* ../dbResAndOther/')
os.system('cp 装备/* ../dbResAndOther/')

sol = os.listdir('士兵')
store = re.compile('soldier\d+.png')
dead = re.compile('soldier\d+dead.png')
count = 0
for i in sol:
    if store.match(i):
        os.system('cp 士兵/%s ../dbResAndOther/'%(i))
        count += 1
    elif dead.match(i):
        os.system('cp 士兵/%s ../dbResAndOther/'%(i))
        count += 1
print "copy sol", count

#coding:utf8
import json
import MySQLdb
con = MySQLdb.connect(host='localhost', user='root', passwd='badperson3', db='Wan2', charset='utf8')

count = 0
#新手剧情闯关图片
sql = 'select * from mapMonster where big = 0 and small = 0'
con.query(sql)
res = con.store_result().fetch_row(0, 1)
for i in res:
    id = i['id']
    os.system('cp 士兵/soldiera%d.png ../dbResAndOther/' % (id))
    os.system('cp 士兵/soldiera%d.plist ../dbResAndOther/' % (id))
    os.system('cp 士兵/soldierm%d.png ../dbResAndOther/' % (id))
    os.system('cp 士兵/soldierm%d.plist ../dbResAndOther/' % (id))
    count += 1
#新手剧情挑战士兵
sql = 'select * from mapMonster where big = 0 and small = 1'
con.query(sql)
res = con.store_result().fetch_row(0, 1)
for i in res:
    id = i['id']
    os.system('cp 士兵/soldiera%d.png ../dbResAndOther/' % (id))
    os.system('cp 士兵/soldiera%d.plist ../dbResAndOther/' % (id))
    os.system('cp 士兵/soldierm%d.png ../dbResAndOther/' % (id))
    os.system('cp 士兵/soldierm%d.plist ../dbResAndOther/' % (id))
    count += 1

#所有英雄的第一级别图片
sql = 'select * from soldier where isHero = 1 and id%10 = 0'
con.query(sql)
res = con.store_result().fetch_row(0, 1)
for i in res:
    id = i['id']
    os.system('cp 士兵/soldiera%d.png ../dbResAndOther/' % (id))
    os.system('cp 士兵/soldiera%d.plist ../dbResAndOther/' % (id))
    os.system('cp 士兵/soldierm%d.png ../dbResAndOther/' % (id))
    os.system('cp 士兵/soldierm%d.plist ../dbResAndOther/' % (id))
    count += 1
    
#初始士兵的图片
sql = 'select * from initSoldierList'
con.query(sql)
res = con.store_result().fetch_row(0, 1)
for i in res:
    id = i['id']
    os.system('cp 士兵/soldiera%d.png ../dbResAndOther/' % (id))
    os.system('cp 士兵/soldiera%d.plist ../dbResAndOther/' % (id))
    os.system('cp 士兵/soldierm%d.png ../dbResAndOther/' % (id))
    os.system('cp 士兵/soldierm%d.plist ../dbResAndOther/' % (id))
    count += 1


print "mapMonster 新手剧情士兵图片", count



con.close()
