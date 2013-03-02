#coding:utf8
import os
import Image
import sys
color = sys.argv[1]

f = os.listdir('.')
def g(a):
    return a.find('png') != -1
f = filter(g, f)
temp = []
for i in f:
    num = i.replace(color, '').replace('.png', '')
    num = int(num)
    temp.append(num)
temp.sort()

f = []
for i in temp:
    f.append(color+str(i)+'.png')

maxBoundary = [1000, 1000, 0, 0]
for i in f:
    name = i
    im = Image.open(name)

    mid = im.size[0]/2
    box = list(im.getbbox())
    dx = max(mid-box[0], box[2]-mid)
    box[0] = mid-dx
    box[2] = mid+dx

    if box[0] < maxBoundary[0]:
        maxBoundary[0] = box[0]
    
    if box[1] < maxBoundary[1]:
        maxBoundary[1] = box[1]

    if box[2] > maxBoundary[2]:
        maxBoundary[2] = box[2]

    if box[3] > maxBoundary[3]:
        maxBoundary[3] = box[3]

os.system('mkdir crop')
for i in f:
    name = i
    im = Image.open(name)
    nim = im.crop(maxBoundary)
    nim.save('crop/%s' % (name))
