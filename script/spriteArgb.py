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
            for p in li:
                if p.find('//') != -1:
                    pass
                elif pat1.search(p) != None or pat2.search(p) != None:
                    data = 'void main(){\n %s }'% (p)
                    lineRes.append(data)        
                    print lno
                    print n

                    newL = gen(data)

                    li[lno] = newL+'\n'
                    print 'old',  p
                    print "new", lno, li[lno]
                    keep = lno
                    #files.write(newL+'\n')
                lno += 1
            if keep != -1:
                print li[keep] 

            print 'len', len(li)
            files = open(n, 'w')
            for l in li:
                files.write(l)
            files.close()

                    
pathNow = sys.argv[1] 
walkThrough(pathNow)

f = open('label.txt', 'w')
f.write(json.dumps(lineRes))
f.close()
