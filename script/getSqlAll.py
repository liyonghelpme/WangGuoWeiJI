#coding:utf8
import MySQLdb
import json
sqlName = ['building','crystal', 'challengeReward', 'drug', 'equip', 'fallThing', 'gold', 'herb', 'levelExp', 'plant', 'prescription', 'silver', 'soldier', 'soldierAttBase', 'soldierGrade', 'soldierKind', 'soldierLevel', 'soldierTransfer',  'allTasks', 'mapDefense',  'soldierName', 'mapReward', 'levelDefense', 'mineProduction', 'goodsList', 'equipLevel', 'magicStone', 'skills', 'monsterAppear', 'statusPossible', 'loveTreeHeart', 'heroSkill', 'mapBlood', 'fightingCost', 'newParam', 'StoreWords', 'StoreAttWords', 'MoneyGameGoods', 'ExpGameGoods', 'equipSkill', 'levelMaxFallGain', 'RoundMonsterNum', 'RoundMapReward']
con = MySQLdb.connect(host='localhost', user='root', passwd='badperson3', db='Wan2', charset='utf8')


sql = 'select * from gold'
con.query(sql)
res = con.store_result().fetch_row(0, 1)
for i in res:
    sql = "update gold set name = '%s' where id = %d" % (str(i['gaingold'])+' 金币', i['id'])
    con.query(sql)

sql = 'select * from silver'
con.query(sql)
res = con.store_result().fetch_row(0, 1)
for i in res:
    sql = "update silver set name = '%s' where id = %d" % (str(i['gainsilver'])+' 银币', i['id'])
    con.query(sql)

sql = 'select * from crystal'
con.query(sql)
res = con.store_result().fetch_row(0, 1)
for i in res:
    sql = "update crystal set name = '%s' where id = %d" % (str(i['gaincrystal'])+' 水晶', i['id'])
    con.query(sql)


sql = 'select * from prescriptionNum'
con.query(sql)
res = con.store_result().fetch_row(0, 1)
nums = {}
for i in res:
    nums[i['id']] = i


def hanData(name, data):
    names = []
    key = []
    res = []
    f = data.fetch_row(0, 1)
    for i in f:
        i = dict(i)
        if i.get('name') != None and i.get('id') != None:
            i['name'] = name+str(i['id'])
        if i.get('engName') != None:
            i.pop('engName')
        it = list(i.items())
        it = [list(k) for k in it]
        #it[4][1] = 'build'+str(i['id'])
        key = [k[0] for k in it]
        a = [k[1] for k in it]
        if i.get('id') != None:
            res.append([i['id'], a])
    #equipId skillId
            
        
    #if name == 'mapBlood':
    #    res = []
    #    for i in f:
    #        res.append()
    if name == 'StoreAttWords':
        names = []
        res = []
        for i in f:
            k = i['key']
            n = 'StoreAttWords%s' % k
            res.append([k, n]);
            names.append([n, i['word']])
        print 'var', name, '=', 'dict(', json.dumps(res), ');'
        return names

    if name == 'StoreWords':
        names = []
        res = []
        for i in f:
            k = i['kind']*10000+i['id']
            n = 'StoreWord%d' % k
            res.append([k,  n])
            names.append([n, i['words']])

        print 'var', name, '=', 'dict(', json.dumps(res), ');'
        return names
    if name == 'newParam':
        res = {}
        for i in f:
            res[i['key']] = i['value']
        res = res.items()
        print 'var', 'PARAMS', '=', 'dict(', json.dumps(res), ');'
        return []
    if name == 'PARAMS':
        res = {}
        for i in f:
            for k in i:
                res[k] = i[k]
        res = res.items()
        print 'var', name, '=', 'dict(', json.dumps(res), ');'
        return []
    if name == 'heroSkill':
        res = []
        for i in f:
            res.append([i['hid'], i['skillId']])
        print 'var', name, '=', 'dict(',json.dumps(res), ');'
        return []
    #if name == 'fightCost':
    #    res = []
    #    return []


    if name == 'loveTreeHeart':
        res = []
        for i in f:
            res = json.loads(i['num'])
        print 'var', name, '=', json.dumps(res), ';'
        return []
    if name == 'statusPossible':
        res = []
        reward = []
        for i in f:
            res.append([i['id'], i['possible']])
            reward.append([i['id'], [i['gainsilver'], i['gaincrystal'], i['gaingold'], [i['sunflower'], i['sun'], i['flower'], i['star'], i['moon']]] ])
        print 'var', name, '=', json.dumps(res), ';'
        key = ['gainsilver', 'gaincrystal', 'gaingold', 'nums']
        print 'var', name+'Key', '=', json.dumps(key), ';'
        print 'var', name+'Data', '=', 'dict(', json.dumps(reward), ');'
        return []


    #bigId--->monsterId
    if name == 'monsterAppear':
        res = dict()
        for i in f:
            r = res.get(i['firstNum']/10, [])
            r.append(i['id'])
            res[i['firstNum']/10] = r
        res = res.items()
        print 'var', name, '=', 'dict(', json.dumps(res), ');'
        return []

    """
    if name == 'mineProduction':
        res = []
        keys = []
        for i in f:
            keys = i.keys()
            res.append(i.items())
        print 'var', name+'Key', '=', json.dumps(keys), ';'
        print 'var', name+'Data', '=', 'dict(', json.dumps(res), ');'
        return []
    """
    if name == 'equipLevel':
        for i in f:
            res = json.loads(i['levelCoff'])
        print 'var', name, '=', json.dumps(res), ';'
        return []
    if name == 'levelDefense':
        res = []
        for i in f:
            res.append([i['level'], i['defense']])
        print 'var', name, '=', json.dumps(res), ';'
        return []
    
    if name == 'mapReward':
        res = []
        for i in f:
            res.append([i['id'], json.loads(i['reward'])])
        print 'var', name, '=', 'dict(', json.dumps(res), ');'
        return []

            
    if name == 'soldierName':
        import codecs
        newFile = codecs.open('../data/Name.as', 'w', 'utf8')

        res = []
        id = 0
        names = []
        for i in f:
            res.append(['name'+str(id), i['maleOrFemale']])
            names.append(['name'+str(id), [i['name'], i['engName']]])
            id += 1
        print 'var', name, '=', json.dumps(res), ';'
        #return []
        
        res =  'var SolNames = dict([\n'
        for n in names:
            #print n
            #n[1][0] = n[1][0].encode('utf8')
            #print json.dumps(n)
            #res += '[ '+ json.dumps(n[0])+' , ["'+n[1][0]+'",'+  ' "'+n[1][1]+'"] ],\n'
            res += '["'+n[0]+'", [ "'+ n[1][0] + '", "'+ n[1][1]+'"]'+'],\n'
        res +=  ']);'
        
        newFile.write(res)
        newFile.close()
        return []
    if name == 'challengeReward':
        for i in f:
            res = json.loads(i['reward'])
        print 'var', name, '=', json.dumps(res), ';'
        return []

    if name == 'soldierTransfer':
        res = []
        for i in f:
            res = json.loads(i['level'])
        print 'var', name, '=', json.dumps(res), ';'
        return []
    if name == 'soldierAttBase':
        res = []
        for i in f:
            res = json.loads(i['base'])
        print 'var', name, '=', json.dumps(res), ';'
        return []
    if name == 'soldierGrade':
        res = []
        for i in f:
            res.append([i['id'], int(i['level']*100)])
        print 'var', name, '=', 'dict(', json.dumps(res), ');'
        return []
    if name == 'soldierKind':
        res = []
        for i in f:
            i['attribute'] = [int(at*100) for at in json.loads(i['attribute'])]
            res.append([i['id'], i['attribute']])

        print 'var', name, '=', 'dict(', json.dumps(res), ');'
        return []
    if name == 'soldierLevel':
        res = []
        for i in f:
            res = json.loads(i['levelData'])
        print 'var', name, '=', json.dumps(res), ';'
        return []
        

    if name == 'mapDefense':
        res = []
        for i in f:
            res.append([i['id'], i['defense']])
        print 'var', name, '=', 'dict(', json.dumps(res), ');'
        return []
            

    if name == 'levelExp':
        res = []
        for i in f:
            res = json.loads(i['exp'])
        print 'var', name, '=', json.dumps(res), ';'
        return [] 
     
    if name == 'RoundMonsterNum':
        res = {}
        key = ['id', 'mons']
        for i in f:
            k = i['id']
            v = [
                [i['kind0'], i['num0']],
                [i['kind1'], i['num1']],
                [i['kind2'], i['num2']],
                [i['kind3'], i['num3']],
                [i['kind4'], i['num4']],
            ]
            temp = []
            for p in v:
                if p[0] != -1:
                    temp.append(p)
            res[k] = [k, temp]
        res = res.items()
        print 'var', name+'Key', '=', json.dumps(key), ';'
        print 'var', name+'Data', '=', 'dict(', json.dumps(res), ');'
        return []

    
    if name == 'mapMonster':#大地图 小关的怪兽位置 类型 等级
        res = {}
        key = []
        for i in f:
            k = i['big']*10+i['small']
            mons = res.get(k, [])
            i.pop('big')
            i.pop('small')
            key = i.keys()
            it = i.values()
            mons.append(it)
            res[k] = mons
        res = res.items()
        print 'var', name+'Key', '=', json.dumps(key), ';'
        print 'var', name+'Data', '=', 'dict(', json.dumps(res), ');'
        return []
    if name == 'soldierLevelExp':
        res = []
        for i in f:
            i = dict(i)
            res.append([i['id'], json.loads(i['exp'])])
        print 'var', name, '=', 'dict(', json.dumps(res), ');'
        return []

    #名字 描述desc 出现复活药水的数据
    if name == 'drug' or name == 'equip' or name == 'skills':
        res = []
        keys = []
        names = []
        #药品有商店名字和全名
        hasStoreName = False
        hasLevelName = False
        for i in f:
            i = dict(i)
            i['name'] = name+str(i['id'])
            i['des'] = name+'Des'+str(i['id'])
            i.pop('engName')
            if i.get('storeName') != None:
                hasStoreName = True
                i['storeName'] = name+'StoreName'+str(i['id'])
            if i.get('levelName') != None:
                hasLevelName = True
                i['levelName'] = name+'LevelName'+str(i['id'])

            it = list(i.items())
            it = [list(k) for k in it]
            key = [k[0] for k in it]
            a = [k[1] for k in it]
            res.append([i['id'], a])

        names = [[name+str(i['id']), [i['name'], i['engName']]] for i in f]
        names += [[name+'Des'+str(i['id']), i['des']] for i in f ]
        if hasStoreName:
            names += [[name+'StoreName'+str(i['id']), i['storeName']] for i in f]
        if hasLevelName:
            names += [[name+'LevelName'+str(i['id']), i['levelName']] for i in f]
        
        print 'var', name+'Key', '=', json.dumps(key), ';'
        print 'var', name+'Data', '=', 'dict(', json.dumps(res), ');'
        return names

    #if name == 'skills':
         
    if name == 'magicStone':
        res = []
        keys = []
        names = []
        for i in f:
            i = dict(i)
            i['name'] = name+str(i['id'])
            i['des'] = name+'Des'+str(i['id'])
            i.pop('engName')
            i.pop('pos0')
            i.pop('pos14')
            i.pop('pos29')
            i.pop('pos44')
            i.pop('pos59')
            i['possible'] = json.loads(i['possible'])
            it = list(i.items())
            it = [list(k) for k in it]
            key = [k[0] for k in it]
            a = [k[1] for k in it]
            res.append([i['id'], a])

        names = [[name+str(i['id']), [i['name'], i['engName']]] for i in f]
        names += [[name+'Des'+str(i['id']), i['des']] for i in f ]
        print 'var', name+'Key', '=', json.dumps(key), ';'
        print 'var', name+'Data', '=', 'dict(', json.dumps(res), ');'
        return names

    if name == 'goodsList':
        res = []
        keys = []
        names = []
        for i in f:
            i = dict(i)
            i['name'] = name+str(i['id'])
            i['des'] = name+'Des'+str(i['id'])
            i.pop('engName')
            i.pop('maxFail')
            i.pop('minFail')
            i.pop('maxBreak')
            i.pop('minBreak')
            i['possible'] = json.loads(i['possible'])

            it = list(i.items())
            it = [list(k) for k in it]
            key = [k[0] for k in it]
            a = [k[1] for k in it]
            res.append([i['id'], a])

        names = [[name+str(i['id']), [i['name'], i['engName']]] for i in f]
        names += [[name+'Des'+str(i['id']), i['des']] for i in f ]
        print 'var', name+'Key', '=', json.dumps(key), ';'
        print 'var', name+'Data', '=', 'dict(', json.dumps(res), ');'
        return names
        
        
    if name == 'herb':#药材中 描述
        res = []
        key = []
        for i in f:
            i = dict(i)
            i['name'] = 'herb'+str(i['id'])
            i['des'] = 'herbDes'+str(i['id'])
            i.pop('engName')
            it = list(i.items())
            it = [list(k) for k in it]
            #it[4][1] = 'build'+str(i['id'])
            key = [k[0] for k in it]
            a = [k[1] for k in it]
            res.append([i['id'], a])
        names = [['herb'+str(i['id']), [i['name'], i['engName']]] for i in f]
        names += [ ['herbDes'+str(i['id']), i['des']] for i in f]
        print 'var', name+'Key', '=', json.dumps(key), ';'
        print 'var', name+'Data', '=', 'dict(', json.dumps(res), ');'
        return names
            

    if name == 'prescription':
        drugId = []
        equipId = []
        res = []
        key = ['id', 'kind', 'level', 'tid', 'needs']
        for i in f:
            i = dict(i)
            needs = []
            numId = i['numId']
            r = nums[numId]
            i['num1'] = r['xNum']
            i['num2'] = r['yNum']
            i['num3'] = r['zNum']
            if i['num1'] != 0:
                needs.append([i['id1'], i['num1']])
            if i['num2'] != 0:
                needs.append([i['id2'], i['num2']])
            if i['num3'] != 0:
                needs.append([i['id3'], i['num3']])
            res.append([i['id'], [i['id'], i['kind'], i['level'], i['tid'], needs]])
            if i['kind'] == 2:
                drugId.append(i['id'])
            else:
                equipId.append(i['id'])
        print 'var', 'PRE_DRUG_ID', '=', json.dumps(drugId), ';'
        print 'var', 'PRE_EQUIP_ID', '=', json.dumps(equipId), ';'

    if name == 'smallMapInfo':
        res = []
        key = ['rewards']
        for i in f:
            i = dict(i)
            rewards = []
            if i['reward0Pos'] > 0:
                rewards.append([i['reward0'], i['reward0Pos']])
            if i['reward1Pos'] > 0:
                rewards.append([i['reward1'], i['reward1Pos']])
            res.append([i['id'], rewards])

    #Words 存放对话框字符串
    #strings 中存放物品名字 任务字符串 之类 来自其它数据表的字符串
    """
    if name == 'Strings':
        res = []

        names = []
        for i in f:
            i = dict(i)
            res.append([i['key'], [i['chinese'], i['english']]])
            names.append([i['key'], [i['chinese'], i['english']]])

        return names
    """

    
    #name list [name, [chinese, english]]
    #res key key = [k[0] for k in it]
    #res data data = [ [id, [k[1] for k in it]] ]
    if name == 'soldier':
        res = []
        key = []
        for i in f:
            i = dict(i)
            #i['stage'] = json.loads(i['stage'])
            i['name'] = 'soldier' + str(i['id'])
            i.pop('engName')
            it = list(i.items())
            it = [list(k) for k in it]
            a = [k[1] for k in it]
            key = [k[0] for k in it]
            res.append([i['id'], a])

        names = [['soldier'+str(i['id']), [i['name'], i['engName']]] for i in f]
        print 'var', name+'Key', '=', json.dumps(key), ';'
        print 'var', name+'Data', '=', 'dict(', json.dumps(res).replace('0.0', '0'), ');'
        return names 
    if name == 'allTasks':
        res = []
        for i in f:
            i = dict(i)
            i['title'] = 'title'+str(i['id'])
            i['des'] = 'des'+str(i['id'])
            i['commandList'] = json.loads(i['commandList'])
            newCom = []
            for c in i['commandList']:
                if c.get('tip') != None:
                    old = c['tip']
                    c['tip'] = 'taskTip'+str(c['msgId'])
                newCom.append(c.items())
            i['commandList'] = newCom

            it = list(i.items())
            it = [list(k) for k in it]
            key = [k[0] for k in it]
            a = [k[1] for k in it]
            res.append([i['id'], a])

        names = [['title'+str(i['id']), i['title']] for i in f]
        names += [ ['des'+str(i['id']), i['des']] for i in f]
        print 'var', name+'Key', '=', json.dumps(key), ';'
        print 'var', name+'Data', '=', 'dict(', json.dumps(res), ');'
        return names

    if name == 'task':#任务的title 和desc 引用字符串中的titleid desid
        for i in f:
            i = dict(i)
            i['title'] = 'title'+str(i['id'])
            i['des'] = 'des'+str(i['id'])
            i['accArray'] = json.loads(i['accArray'])
            it = list(i.items())
            it = [list(k) for k in it]
            key = [k[0] for k in it]
            a = [k[1] for k in it]
            res.append([i['id'], a])
        names = [['title'+str(i['id']), i['title']] for i in f]
        names += [ ['des'+str(i['id']), i['des']] for i in f]
        print 'var', name+'Key', '=', json.dumps(key), ';'
        print 'var', name+'Data', '=', 'dict(', json.dumps(res), ');'
        return names

            
            

    if f[0].get('name', None) != None:
        if f[0].get('engName') != None:
            names = [ [name+str(i['id']), [i['name'], i.get('engName')]] for i in f]
        else:
            names = [ [name+str(i['id']), i['name']] for i in f]
            
    else:
        names = []


    #print json.dumps(names)
    #for n in names:
    #    print '[','"'+n[0]+'"', ',','"'+ n[1]+'"','],'

    print 'var', name+'Key', '=', json.dumps(key), ';'
    print 'var', name+'Data', '=', 'dict(', json.dumps(res), ');'
    return names
        
allNames = []
for i in sqlName:
    sql = 'select * from '+i
    con.query(sql)
    res = con.store_result()
    allNames += hanData(i, res)
        

SOL = 7
EQUIP = 1
BUILD = 0

levels = {}
sql = 'select * from soldier'
con.query(sql)
res = con.store_result().fetch_row(0, 1)

for i in res:
    if i['id']%10 == 0:
        l = levels.get(i['level'], [])
        l.append([SOL, i])
        levels[i['level']] = l

sql = 'select * from equip'
con.query(sql)
res = con.store_result().fetch_row(0, 1)

for i in res:
    l = levels.get(i['level'], [])
    l.append([EQUIP, i])
    levels[i['level']] = l

sql = 'select * from building'
con.query(sql)
res = con.store_result().fetch_row(0, 1)

for i in res:
    if i['funcs'] == 2:
        l = levels.get(i['level'], [])
        l.append([BUILD, i])
        levels[i['level']] = l
#old = levels
res = []

levels = levels.items()
levels.sort()
maxLevel = levels[-1][0]
for l in levels:
    #print l[0]
    #for i in l[1]:
    #    print i[1]['name'].encode('utf8')

    res.append([l[0], [[i[0], i[1]['id']] for i in l[1]]])

import json
print 'var', 'levelUpdate', '=', 'dict(' ,json.dumps(res), ');'
print 'const', 'MAX_LEVEL', '=', maxLevel, ';'


#商店士兵 类型只有 初级士兵 和 怪兽
sql = 'select * from soldier order by level'
con.query(sql)
res = con.store_result().fetch_row(0, 1)
showId = []
#显示凤凰？ 地狱火 魔法类型怪兽
for r in res:
    if r['id'] % 10 == 0 and r['isHero'] == 0:
        showId.append(r['id'])

print 'var', 'storeSoldier', '=', json.dumps(showId), ';'
    





import codecs
strFile = codecs.open('../data/String.as', 'w', 'utf8')
strCon = 'const LANGUAGE = 0;\n'
strCon +=  'var strings = dict([\n'
for n in allNames:
    if type(n[1]) == type([]):
        strCon +=  '["'+n[0]+'", ['+'"'+ n[1][0] + '", "'+ n[1][1]+'"]'+'],\n'
    else:
        strCon += '["'+n[0]+'", "'+ n[1]+'"],\n'
strCon += ']);'
strFile.write(strCon)
strFile.close()

decor = []
sql = 'select * from building where funcs = 2 order by level asc'
con.query(sql)
dec = con.store_result().fetch_row(0, 1)
for i in dec:
    decor.append([0, i['id']])

equips = []
sql = 'select * from equip order by level asc'
con.query(sql)
eq = con.store_result().fetch_row(0, 1)
for i in eq:
    equips.append([1, i['id']])

StoreGoods = [
        [[3, 0], [3, 1], [3, 2], [3, 3], [3, 4], [4, 0], [4, 1], [4, 2], [5, 0], [5, 1], [5, 2]],
        [[0, 0], [0, 1], [0, 10], [0, 12], [0, 224], [0, 300]],
        [[0, 100], [0, 140], [0, 142], [0, 144], [0, 102], [0, 104], [0, 106], [0, 108], [0, 110], [0, 112], [0, 114], [0, 116], [0, 118], [0, 120], [0, 122], [0, 124], [0, 128], [0, 130], [0, 132], [0, 134], [0, 136], [0, 138], [0, 146], [0, 148], [0, 150], [0, 152], [0, 154], [0, 156], [0, 158], [0, 160], [0, 162], [0, 164], [0, 178]],
        [[1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8], [1, 9], [1, 10], [1, 11], [1, 12], [1, 13], [1, 14], [1, 15], [1, 16], [1, 17], [1, 18], [1, 19], [1, 20], [1, 21], [1, 22], [1, 23], [1, 24], [1, 25], [1, 26], [1, 27], [1, 28], [1, 29], [1, 30], [1, 31], [1, 32], [1, 33], [1, 34], [1, 35], [1, 36], [1, 37], [1, 38], [1, 39], [1, 40], [1, 41], [1, 42], [1, 43], [1, 44], [1, 45], [1, 46], [1, 47], [1, 48], [1, 49], [1, 50], [1, 51], [1, 52], [1, 53], [1, 54], [1, 55], [1, 56], [1, 57], [1, 58], [1, 59], [1, 60], [1, 61], [1, 62], [1, 63], [1, 64], [1, 65], [1, 66], [1, 67], [1, 68], [1, 69], [1, 70], [1, 71], [1, 72], [1, 73], [1, 74], [1, 75], [1, 76], [1, 77], [1, 78], [1, 79], [1, 80], [1, 81], [1, 82], [1, 83], [1, 84], [1, 85], [1, 86], [1, 87], [1, 88], [1, 89], [1, 90], [1, 91], [1, 92], [1, 93], [1, 94], [1, 95], [1, 96], [1, 97], [1, 98], [1, 99], [1, 100], [1, 101], [1, 102], [1, 103], [1, 104], [1, 105], [1, 106], [1, 107], [1, 108], [1, 109], [1, 110], [1, 111], [1, 112], [1, 113], [1, 114], [1, 115], [1, 116], [1, 117], [1, 118], [1, 119], [1, 120], [1, 121], [1, 122], [1, 123], [1, 124], [1, 125], [1, 126], [1, 127], [1, 128], [1, 129], [1, 130], [1, 131], [1, 132], [1, 133]],

        [[2, 1], [2, 4], [2, 10], [2, 13], [2, 21], [2, 24], [2, 31], [2, 34]],
]
StoreGoods[2] = decor
StoreGoods[3] = equips
print 'var', 'StoreGoods', '=', json.dumps(StoreGoods), ';'

sql = 'select * from loginReward'
con.query(sql)
res = con.store_result().fetch_row(0, 1)
LoginReward = []
for i in res:
    LoginReward.append([i['id'], i['gold']])
print 'var', 'LoginReward', '=', json.dumps(LoginReward), ';'

AccCost = []
sql = 'select * from AccCost'
con.query(sql)
res = con.store_result().fetch_row(0, 1)
for i in res:
    AccCost.append([i['id'], i['gold']])
print 'var', 'AccCost', '=', json.dumps(AccCost), ';'

HARM_TABLE = [
[100, 150, 100, 100],
[100, 100, 150, 100],
[150, 100, 100, 100],
[100, 100, 100, 100],
]
print 'const', 'HARM_TABLE', '=', json.dumps(HARM_TABLE), ';'

con.commit()
con.close()
