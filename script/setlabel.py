#coding:utf8
import os
import re
from hanlabel import *
from os import path

pat1 = re.compile('curScene\.addChild\(new UpgradeBanner')
indentSpace = re.compile('^ +')

import json
lineRes = []

def walkThrough(cur):

    f = os.listdir(cur)
    for i in f:
        print i
        n = path.join(cur, i)
        if path.isdir(n):
            walkThrough(n)
        elif n.find('.as') != -1 and n.find('swp') == -1:
            print n
            oldF = open(n)
            li = oldF.readlines()
            oldF.close()

            lno = 0
            keep = -1
            find = False
            for p in li:
                beginSpace = ''
                indent = indentSpace.findall(p)
                if len(indent) > 0:
                    beginSpace = indent[0]
                print p
                if p.find('//') != -1:
                    pass
                elif pat1.search(p) != None :
                    data = 'void main(){\n %s }'% (p)
                    lineRes.append(data)        
                    print lno
                    print n

                    newL = gen(data)
                    newL = beginSpace+newL

                    li[lno] = newL+'\n'
                    print 'old',  p
                    print 'beginSpace', len(beginSpace)
                    print "new", lno, li[lno]
                    keep = lno
                    #files.write(newL+'\n')
                    find = True
                lno += 1
            if keep != -1:
                print li[keep] 

            print 'len', len(li)
            if find:
                files = open(n, 'w')
                for l in li:
                    files.write(l)
                files.close()

                    
walkThrough('../')

f = open('label.txt', 'w')
f.write(json.dumps(lineRes))
f.close()
