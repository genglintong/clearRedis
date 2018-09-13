## 找到长期未使用的redis键 并且清理空间

### 更新 2.0
- 按照每 1000条执行 并且保存key值

### 执行 ./ceshi.sh

- 修改 临界时间  修改getUnusedData.lua maxTime 
- 修改数据库  将ceshi.sh redis连接改变

### 本机测试
- 查找126万key信息 并且删除 用时 9s <br>

 apple@localhost  ~/genglintong/LUA/redis_clear   master ●  ./ceshi.sh <br>
开始时间：2018-09-11 10:46:24 <br>
结束时间：2018-09-11 10:46:33 <br>
 apple@localhost  ~/genglintong/LUA/redis_clear   master ●  wc ceshi_keys.txt <br>
 1265110 1265110 17641113 ceshi_keys.txt <br>

 ### 缺陷
 暂时只考虑了一个数据库 即select 0 <br>