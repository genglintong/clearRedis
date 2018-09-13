#!/bin/bash

time=$(date "+%Y-%m-%d %H:%M:%S")
echo "开始时间：${time}"

# 开始执行
#redis-cli -p 3310 -a password --eval getUnusedData.lua > keys.txt
redisCom="redis-cli -p 3310 -a haibian1qazxsw2"
start=0
fileNamePre="unUseData_"

time=$(date "+%Y-%m-%d %H:%M:%S")
echo "拆分执行 开始时间：${time} 开始索引 ${start}"
data=`${redisCom} --eval getUnusedData2.0.lua , ${start}`
echo ${data} | sed 's/ /  \n/g' > "${fileNamePre}""${start}"
start=`echo ${data} | cut -d ' ' -f1`
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "拆分执行 结束时间：${time}"

while(( $start>0 ))
do
    time=$(date "+%Y-%m-%d %H:%M:%S")
    echo "拆分执行 开始时间：${time} 开始索引 ${start}"
    data=`${redisCom} --eval getUnusedData2.0.lua , ${start}`
    echo ${data} | sed 's/ /  \n/g' > "${fileNamePre}""${start}"
    start=`echo ${data} | cut -d ' ' -f1`
    time=$(date "+%Y-%m-%d %H:%M:%S")
    echo "拆分执行 结束时间：${time}"
done

time=$(date "+%Y-%m-%d %H:%M:%S")
echo "结束时间：${time}"
