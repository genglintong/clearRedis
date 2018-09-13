-- 获取键值/参数
local key,offset,limit = KEYS[1] , ARGV[1] , ARGV[2]

-- 获取键的有序集合
local names = redis.call('ZRANGE', key, offset , limit)

-- 获取存储web信息
local infos = {}

for i=1 , #names do
    local ck = names[i]

    -- 获取每个WEB所有信息
    local info = redis.call('HGETALL', ck)

    -- 将信息插入对应集合
    table.insert(info , 'HOST_NAME')
    table.insert(info , names[i])

    --存储至 infos
    infos[i] = info
end

--返回结果
return infos
