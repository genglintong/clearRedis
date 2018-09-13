#!/bin/bash

time=$(date "+%Y-%m-%d %H:%M:%S")
echo "开始时间：${time}"

# 开始执行
#redis-cli -p 3310 -a password --eval getUnusedData.lua > keys.txt
redis-cli --eval getUnusedData.lua > ceshi_keys.txt

time=$(date "+%Y-%m-%d %H:%M:%S")
echo "结束时间：${time}"
