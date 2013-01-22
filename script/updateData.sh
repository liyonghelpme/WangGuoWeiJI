#!/bin/bash
#writeCommandTip 只在第一次加入的时候 自动更新新的tip 到Strings中  重复的将自动忽略
python writeCommandTip.py
python getString.py
python saveSqlTemplate.py
