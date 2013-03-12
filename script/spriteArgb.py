#coding:utf8
import os
import re
from hanSpriteArgb import *
from os import path
import sys

pat1 = re.compile('addsprite\(')
pat2 = re.compile('sprite\(')

import json
lineRes = []

def walkThrough(cur):

    f = os.listdir(cur)
    for i in f:
        n = path.join(cur, i)
        if path.isdir(n):
            walkThrough(n)
        elif n.find('as') != -1 and n.find('swp') == -1:
            oldF = open(n)
            li = oldF.readlines()
            oldF.close()

            lno = 0
            keep = -1
            #原来的文本中有多行 汇聚成一行 分析结束之后 变成一条语句
            #保存新的文本可能 行会减少
            #状态 Find Line End 寻找行的结束
            newText = []
            state = 'Start'
            cacheLine = ''
            for p in li:
                if state == 'Start':
                    if p.find('//') != -1:#注释行 不分析
                        newText.append(p)
                        pass
                    #有addsprite sprite 行
                    elif pat1.search(p) != None or pat2.search(p) != None:
                        cacheLine = p
                        if p.find(';') == -1:
                            #cacheLine = p
                            state = 'Find'
                        else:
                            data = 'void main(){\n %s }'% (cacheLine)
                            lineRes.append(data)        
                            print lno
                            print n

                            newL = gen(data)

                            #li[lno] = newL+'\n'
                            newText.append(newL+'\n')
                            print 'old',  cacheLine
                            print "new", lno, newText[-1]
                            keep = lno

                    else:
                        newText.append(p)
                elif state == 'Find':
                    if p.find(';') == -1:
                        cacheLine += p
                    else:
                        cacheLine += p
                        state = 'Start'
                        data = 'void main(){\n %s }'% (cacheLine)
                        lineRes.append(data)        
                        print lno
                        print n

                        newL = gen(data)

                        #li[lno] = newL+'\n'
                        newText.append(newL+'\n')
                        print 'old',  cacheLine
                        print "new", lno, newText[-1]
                        keep = lno

                    
            print 'len', len(newText)
            files = open(n, 'w')
            for l in newText:
                files.write(l)
            files.close()

                    
pathNow = sys.argv[1] 
walkThrough(pathNow)

f = open('label.txt', 'w')
f.write(json.dumps(lineRes))
f.close()
