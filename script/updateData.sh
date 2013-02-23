#!/bin/bash
python updateEquipDes.py
python updateBuildingCost.py
#writeCommandTip 只在第一次加入的时候 自动更新新的tip 到Strings中  重复的将自动忽略
#暂时不更新技能数据
#python insertSkill.py
python writeCommandTip.py

python saveSqlTemplate.py
#首先处理数据库 生成闯关tip内容 接着再生成字符串
python getString.py
