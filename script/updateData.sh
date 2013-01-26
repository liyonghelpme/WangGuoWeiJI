#!/bin/bash
#writeCommandTip 只在第一次加入的时候 自动更新新的tip 到Strings中  重复的将自动忽略
#暂时不更新技能数据
#python insertSkill.py
python writeCommandTip.py
python getString.py
python saveSqlTemplate.py
