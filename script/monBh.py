#coding:utf8
import os
import MySQLdb
import json
import random
con = MySQLdb.connect(host='localhost', user='root', passwd='badperson3', db='Wan2', charset='utf8')

def getRoundMons():
    sql = 'select * from soldier where solOrMon = 1'
    con.query(sql)
    res = con.store_result().fetch_row(0, 1)
    solName = {}
    for i in res:
        solName[i['name'].encode('utf8')] = i
    f = open('monster.csv').readlines()
    roundMon = []
    for i in f:
        i = i.split(',')
        names = []
        nums = []
        ids = []
        for k in xrange(1, 11, 2):
            #print i[k]
            if i[k] != "":
                if i[k] in solName:
                    names.append(i[k])
                    nums.append(int(i[k+1]))
                    ids.append(solName[i[k]])
                    solName[i[k]]['number'] = int(i[k+1])
                else:
                    print 'error name', i[k]
        yield ids
        #roundMon.append(ids)
    #return roundMon
#0 1 2 3 4 5
#1
#2
#3
#4
#5
#放置若干个士兵
class WorldStatus(object):
    #mons id -> number attack health attribute
    def __init__(self, mons):
        self.board = {}
        self.mons = mons
        self.SolId = 0
        self.solIdMon = {}
    #放置 5个怪兽到 第一排最多
    def putSol(self, m):
        for i in xrange(0, m['number']):
            find = False
            for x in xrange(0, 5):
                for y in xrange(0, 5):
                    sx = m['sx']
                    sy = m['sy']
                    col = False
                    for mx in xrange(0, sx):
                        for my in xrange(0, sy):
                            if self.board.get((x+mx, y+my)) != None or x+mx >= 5 or y+my >= 5:
                                col = True
                                break
                        if col:
                            break
                    #找到合适位置
                    if not col:
                        self.solIdMon[self.SolId] = m
                        for mx in xrange(0, sx):
                            for my in xrange(0, sy):
                                self.board[(x+mx, y+my)] = self.SolId
                        self.SolId += 1
                        m['number'] -= 1#数量减少
                        find = True
                        break
                if find:
                    break
            #只放置1个士兵
            if find:
                break

    def printBoard(self):
        for y in xrange(0, 5):
            for x in xrange(0, 5):
                if self.board.get((x, y)) != None:
                    print self.solIdMon[self.board[(x, y)]]['name'],
                else:
                    print 'x',
            print 

    #检测某个怪兽是否可以放置
    def checkPutable(self, m):
        #print 'checkPutable', m
        for x in xrange(0, 5):
            for y in xrange(0, 5):
                sx = m['sx']
                sy = m['sy']
                col = False
                for mx in xrange(0, sx):
                    for my in xrange(0, sy):
                        if self.board.get((x+mx, y+my)) != None or x+mx >= 5 or y+my >= 5:
                            col = True
                            break
                    if col:
                        break
                if not col:
                    find = True
                    return True
        return False

                        
                        

class Task(object):
    def __init__(self):
        self.children = []
    def run(self):
        pass
    def addChild(self, c):
        self.children.append(c)
class Selector(Task):
    def __init__(self):
        super(Selector, self).__init__()
    def run(self):
        for c in self.children:
            if c.run():
                return True
        return False

class Sequence(Task):
    def __init__(self):
        super(Sequence, self).__init__()
    def run(self):
        for c in self.children:
            if not c.run():
                return False
        return True
class Not(Task):
    def __init__(self):
        super(Not, self).__init__()
    def run(self):
        return not self.children[0].run()


#寻找血牛 高生命值 不是远程
#可能没有近战士兵
#如果不是前线 则 且有远程 则 优先放置远程士兵
class FindDefenser(Task):
    def __init__(self, status):
        super(FindDefenser, self).__init__()
        self.status = status
    def run(self):
        heal = 0
        allHealId = []
        for m in self.status.mons:
            if self.status.mons[m]['healthBoundary'] >= heal and self.status.mons[m]['range'] == 0 and self.status.mons[m]['number'] > 0:#近战
                if self.status.mons[m]['healthBoundary'] > heal:
                    if self.status.checkPutable(self.status.mons[m]):
                        heal = self.status.mons[m]['healthBoundary']
                        allHealId = [m]
                else:
                    if self.status.checkPutable(self.status.mons[m]):
                        allHealId.append(m)
        
        if len(allHealId) > 0:
            rd = random.randint(0, len(allHealId)-1)
            self.status.putSol(self.status.mons[allHealId[rd]])#删除这几个士兵
            return True
        return True

#前线有位置 且 有近战士兵
class FrontHasPos(Task):
    def __init__(self, status):
        super(FrontHasPos, self).__init__()
        self.status = status
    def run(self):
        x = 0
        for y in xrange(0, 5):
            if self.status.board.get((x, y)) == None:
                return True
        return False
#有1个格子的近战士兵
class FrontPutMon(Task):
    def __init__(self, status):
        super(FrontPutMon, self).__init__()
        self.status = status
    def run(self):
        for m in self.status.mons:
            mon = self.status.mons[m]
            if mon['range'] == 0 and mon['sx'] == 1 and mon['sy'] == 1:
                return True
        return False
            

#放置弓箭手 法师 远程部队
#第一批次远程部队当前位置 放置士兵 和 不 放置士兵 两种可能性
#可能没有远程士兵
#放置前线 且 有 可放置的近战士兵 则不放置远程
class FindFarAway(Task):
    def __init__(self, status):
        super(FindFarAway, self).__init__()
        self.status = status
    
    #先近距离 高攻击力
    def run(self):
        allFarId = []
        for m in self.status.mons:
            if self.status.mons[m]['range'] > 0 and self.status.mons[m]['number'] > 0:
                if self.status.checkPutable(self.status.mons[m]):
                    allFarId.append(m)

        if len(allFarId) > 0 :
            rd = random.randint(0, len(allFarId)-1)
            self.status.putSol(self.status.mons[allFarId[rd]])
            return True
        return True   

#有体积可以放入剩余位置的怪兽存在
class HasMonPutable(Task):
    def __init__(self, status):
        super(HasMonPutable, self).__init__()
        self.status = status
    def run(self):
        find = False
        for m in self.status.mons:
            m = self.status.mons[m]
            if m['number'] > 0:
                if self.status.checkPutable(m):
                    return True
        return False
#随机放置剩下的士兵
#可能没有剩余士兵
#Util 所有的士兵 都 被分配完 
class RandPutSol(Task):
    def __init__(self, status):
        super(RandPutSol, self).__init__()
        self.status = status
    def run(self):
        leftMons = []
        for m in self.status.mons:
            if self.status.mons[m]["number"] > 0:
                leftMons.append(self.status.mons[m])
        if len(leftMons) > 0:
            rd = random.randint(0, len(leftMons)-1)
            self.status.putSol(leftMons[rd])
            return False
        return True
            
        
#所有当前可以放置空间的士兵都被放置
"""
class IsAllPut(Task):
    def __init__(self, status):
        super(IsAllPut, self).__init__()
        self.status = status
    def run(self):
        if len(self.status.board) == 25:#棋盘用光
            return True
        #print self.status.mons
        for m in self.status.mons:
            #print m
            if self.status.mons[m]['number'] > 0:
                return False
        return True
"""

class HasFarAway(Task):
    def __init__(self, status):
        super(HasFarAway, self).__init__()
        self.status = status
    def run(self):
        for m in self.status.mons:
            mon = self.status.mons[m]
            if mon['number'] > 0 and mon['range'] > 0:
                return True
        return False
        
#不是前线 且 有远程
class CheckPosAndFarAway(Task):
    def __init__(self, status):
        super(CheckPosAndFarAway, self).__init__()
        self.status = status
    def run(self):
        def checkHasFarAway():
            for m in self.status.mons:
                mon = self.status.mons[m]
                if mon['number'] > 0 and mon['range'] > 0:
                    return True
            return False

        #获取第一个可以放置士兵的位置
        #检测当前位置 是否前线 
        #检测是否有远程士兵可以放置
        def checkCurPos():
            x = 0
            for y in xrange(0, 5):
                if self.status.board.get((x, y)) == None:
                    return False
            #非前线 有 远程 士兵可以安排则
            if checkHasFarAway():
                return True
            return False
        return checkCurPos()
            
        
             
def genMons(m):
    mons = {}
    for k in m:
        sql = 'select id, name, attackType, attack, defenseType, defense, healthBoundary, `range`, sx, sy from soldier where id = %d' % (k)
        con.query(sql)
        mon = con.store_result().fetch_row(0, 1)
        mon[0]['number'] = m[k]
        mons[k] = mon[0]
    return mons
    
def realDo(r):
    mons = dict([[k['id'], k['number']]for k in r])
    print 'mons', mons
    mons = genMons(mons)
    status = WorldStatus(mons)
    #摆放所有的士兵true
    root = Sequence()
    #首先放血牛 接着放远程
    sel = Selector()
    seq = Sequence()
    sel1 = Selector()
    sel2 = Selector()
    sel3 = Selector()
    seq1 = Sequence()
    notDec = Not()
    notDec1 = Not()
    notDec2 = Not()
    seq2 = Sequence()

    #isAllPut = IsAllPut(status)
    hasMonPutable1 = HasMonPutable(status)

    findDefenser = FindDefenser(status)
    findFarAway = FindFarAway(status)
    randPutSol = RandPutSol(status)#随机放置士兵
    checkPosAndFarAway = CheckPosAndFarAway(status)
    frontHasPos = FrontHasPos(status)
    frontPutMon = FrontPutMon(status)
    hasMonPutable = HasMonPutable(status)
    frontHasPos2 = FrontHasPos(status)
    hasFarAway = HasFarAway(status)

    root.addChild(sel)
    #sel.addChild(isAllPut)

    sel.addChild(notDec1)
    notDec1.addChild(hasMonPutable1)
    
    sel.addChild(seq)
    seq.addChild(sel1)
    #sel1.addChild(checkPosAndFarAway)#非前线 且有远程
    sel1.addChild(seq2)
    seq2.addChild(notDec2)
    notDec2.addChild(frontHasPos2)
    seq2.addChild(hasFarAway)

    sel1.addChild(findDefenser)
    seq.addChild(sel2)
    sel2.addChild(seq1)
    seq1.addChild(frontHasPos)
    seq1.addChild(frontPutMon)
    sel2.addChild(findFarAway)
    seq.addChild(sel3)
    #仍有怪兽可以放置
    sel3.addChild(notDec)
    notDec.addChild(hasMonPutable)

    #sel3.addChild(randPutSol)
    count = 0
    while not root.run():
        print '------'
        #count += 1
        status.printBoard()
        if count >= 100:
            print "error", count
            status.printBoard()
            break


    status.printBoard()
    #raw_input()

def main(selRound):
    #5 个骷髅兵
    roundId = 0
    print 'selRound', selRound

    for r in getRoundMons():
        print 'roundId ', roundId
        if selRound != None:
            if roundId != selRound:
                roundId += 1
                continue

        realDo(r)
        roundId += 1

import sys
selRound = None
if len(sys.argv) >= 2:
    selRound = int(sys.argv[1])
main(selRound)
