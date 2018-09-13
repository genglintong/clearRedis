-- 初始化游标为 0
local start = ARGV[1]
-- redis键的匹配规则
local match = '*'
-- 每一次count 的条数
local count = 1000
-- 获取最长未使用时间 临界值
local maxTime = 2592000
-- 存储键值
local keyData = {}
local data = {}

-- 获取部分key 增量迭代
local function nextCycle(start , count, match)
      return redis.call("SCAN", start, "MATCH", match, "COUNT", count)
end

-- 拿到某个key的空转时间
local function getIdleTime(key)
    return redis.call("OBJECT", "IDLETIME", key)
end

-- 删除某个key
local function delKey(key)
    return redis.call("DEL", key)
end

-- 获取key的值
local function getkey(key)
    local type = redis.call("TYPE", key)['ok']

    -- string 类型
    if(type == 'string')
    then
        return redis.call("GET", key) , type
    end

    --  列表
    if(type == 'list')
    then
        return redis.call("LRANGE", key , 0 , -1) , type
    end

    -- 集合
    if(type == 'set')
    then
        return redis.call("SMEMBERS", key) , type
    end

    -- 哈希表
    if(type == 'hash')
    then
        return redis.call("HGETALL", key) , type
    end

    -- 有序集合
    if(type == 'zset')
    then
        return redis.call("ZRANGE", key , 0 , -1 , "WITHSCORES") , type
    end

    return type , type
end

-- 删除数据
local function delUnuseData(keyData)
    for key, value in pairs(keyData)
    do
        local k = value[1]
        delKey(k)
    end
end

-- 获取在临界时间外的数据
local function getUnuseData()
    data = nextCycle(start, count, match)
    start = tonumber(data[1])

    --开始判断
    for key,value in pairs(data[2])
    do
        local curTime = 0
        curTime =  getIdleTime(value)
        if(curTime > maxTime)
        then
            local delData = {}
            delData[1]  = value
            delData[2]  = curTime
            delData[3] , delData[4]  = getkey(value)
            --return delData
            --delKey(value)
            table.insert(keyData , delData)
            --delKey(value)
        end
    end

    return keyData , start
end


keyData , start = getUnuseData()
--redis.replicate_commands()
-- 删除key 则执行下面函数
--delUnuseData(keyData)
table.insert(keyData , 1 ,start)

return keyData
