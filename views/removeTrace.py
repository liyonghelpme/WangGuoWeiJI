import os
import os.path as path

def tranverse(cur):
    f = os.listdir(cur)
    for i in f:
        if path.isdir(i):
            tranverse(path.join(cur, i))
        else if i.find('as') != -1:
            o = open(path.josn(cur, i), 'w')
            li = o.readlines()
            res = ""
            for l in li:
                if l.find("trace") != -1 and l.find("//") == -1:
                    l = "//"+l
                res += l
            o.write(res)
tranverse('.')

