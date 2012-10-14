#coding:utf8
import os
#template = os.path.join(os.environ['HOME'], 'Desktop', 'Papaya-8', 'PapayaGameSDK', 'projects', 'WangGuoWeiJi', 'data', 'Static.as')
template = os.path.join('../data/Static.as')
os.system('python getSqlAll.py > %s' % template)
