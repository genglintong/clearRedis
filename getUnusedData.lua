-- 初始化游标为 0
local start = 0
-- redis键的匹配规则
local match = '*'
-- 每一次count 的条数
local count = 1000
-- 获取最长未使用时间 临界值
local maxTime = 60
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

local function getUnuseData()
    while true do
        --table.insert(keyData, start)
        data = nextCycle(start, count, match)
        start = tonumber(data[1])
    
        --table.insert(keyData , data[2])
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
                --return delData
                --delKey(value)
                table.insert(keyData , delData)
                --delKey(value)
            end
        end
    
        if(start == 0)
        then
            return keyData
        end
    end
end

local function delUnuseData(keyData)
    for key, value in pairs(keyData)
    do
        local k = value[1]
        delKey(k)
    end
end

keyData = getUnuseData()
redis.replicate_commands()
-- 删除key 则执行下面函数
-- delUnuseData(keyData)

return keyData
