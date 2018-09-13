-- 测试使用 为数据库创建随机数据

-- 随机数
local num = 1000000

local function createRaw(num)
    local value = math.random(num)
    local key = "create_rew_data_"..tostring(math.random(num))
    --local value = math.randomseed(num)
    --return value
    return redis.call("SET" , key, value)
end

math.randomseed(num)
--return num
--return createRaw(num)

for i=num,1,-1
do
    createRaw(num)
end

