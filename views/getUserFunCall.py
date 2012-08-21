#coding:utf8
import os
from os import path

f = open('tempUser', 'r').readlines()
fname = []
import re
pat = re.compile(' |function')

for l in f:
    if l.find('function') != -1:
        l = re.sub(pat, '', l)
        l = l.split('(')[0]
        fname.append(l)
print fname

def walkThrough(cur):
    f = os.listdir(cur)
    for i in f:
        n = path.join(cur, i)
        if path.isdir(n):
            walkThrough(n)
        elif n.find('.as') != -1:
            o = open(n).readlines()
            for l in o:
                for fn in fname:
                    if l.find(fn) != -1:
                        print n
                        print l
def main():
    walkThrough('.')
main()
            
