#coding:utf8
#输入 技能的开始编号 到 结束编号 将 skill编号a0 - ... 的图片组合到 ../tempPlist 中



import os
import Image
import sys
#得到最小 2次幂值
def getMin2(v):
    old = v
    id = 0
    while (v>>1) > 0:
        v = v >> 1
        id += 1
    res = 1 << id
    if res < old:
        res = res << 1
    return res


#生成plist文件 不需要col
#kind soldiermId soldieraId soldierfaId soldierfmId  kind = m kind = a kind =fa kind = fm
#width 图片宽度 height 图片高度 总
#size 单个图片的大小
#num 图片的数量
#colNum 每行列的数量
#rowNum 总共行的数量

def savePlistFile(id, width, height, num, size, colNum, rowNum):
    frames = {}
    for k in range(0, num):
        curCol = k%colNum
        curRow = k/colNum

        frames['skill'+str(id)+'a'+str(k)+'.png'] = {
            "frame":"{{"+str(curCol*size[0])+","+str(curRow*size[1])+"},{"+str(size[0])+","+str(size[1])+"}}",
            "offset":"{0, 0}",
            "sourceSize":"{"+str(size[0])+","+str(size[1])+"}",
            "sourceColorRect":"{{0, 0}, {"+str(size[0])+","+str(size[1])+"}}",
            "rotated":False
        }

    picName = 'skilla'+id+'.png'
    print picName, id, num

    metadata = {"format":2, "realTextureFileName":picName, "size":"{"+str(width)+","+str(height)+"}", "textureFileName":picName}
    return {"frames":frames, "metadata":metadata}

import plistlib
#soldier Id color res/blue
#士兵 特征色 攻击 行走

#skillaId.png skillId.plist

#skillId.plist ---> skillaId.png
#skillIdaId.png
def makePlist(id):
    #print id, solOrFea
    nim = None
    global skillNum
    num = skillNum[id]+1
    id = str(id)
    #att = 'a'
    #mov = 'm'
    #if solOrFea == 'f':
    #    att = 'fa'
    #    mov = 'fm'
    for k in range(0, num):#attack
        im = Image.open('skill'+id+'a'+str(k)+'.png')
        if nim == None:
            colNum = 1024/im.size[0]
            rowNum = (num+colNum-1)/colNum

            width = getMin2(im.size[0]*colNum)
            height = getMin2(im.size[1]*rowNum)

            nim = Image.new('RGBA', (width, height), (0, 0, 0, 0))
        curCol = k%colNum
        curRow = k/colNum
        box = (curCol*im.size[0], curRow*im.size[1], im.size[0]*curCol+im.size[0], curRow*im.size[1]+im.size[1])
        nim.paste(im, box)
    nim.save('tempPlist/skilla'+id+'.png')
    res = savePlistFile(id, width, height, num, im.size, colNum, rowNum)
    plistlib.writePlist(res, 'tempPlist/skill'+id+'.plist')

        
        
skills = os.listdir('.')
skillNum = {}#0--->0 1 2 3 4 ... k
for sk in skills:
    if sk.find('png') != -1 and sk.find('a') != -1:
        kind = int(sk.split('a')[0].replace('skill', ''))
        id = int(sk.split('a')[1].replace('a', '').replace('.png', ''))
        print sk, kind, id
        v = skillNum.get(kind, -1)
        if v < id:
            v = id
        skillNum[kind] = v
import json
print skillNum
for k in skillNum:
    p = []
    kind = k
    num = skillNum[k]+1
    for i in range(0, num):
        p.append('skill%d.plist/skill%da%d.png' % (kind, kind, i))
    p = [kind, [p, 1500, 'skill%d.plist' % (kind)]]
    print json.dumps(p), ','
 
start = int(sys.argv[1])
end = int(sys.argv[2])

def main():
    for i in range(start, end):
        makePlist(i)
#print solOrFea == 'f'
main()
