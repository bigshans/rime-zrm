-- fastdict.lua
local fastdict = {}
fastdict.__index = fastdict

-- 从二进制文件加载
function fastdict.load(path)
    local f = assert(io.open(path, "rb"))
    local data = f:read("*a")
    f:close()

    local pos = 1
    local count
    count, pos = string.unpack("<I4", data, pos)

    local arr = {}
    for i = 1, count do
        local clen; clen, pos = string.unpack("<I2", data, pos)
        local code = data:sub(pos, pos + clen - 1)
        pos = pos + clen

        local llen; llen, pos = string.unpack("<I2", data, pos)
        local char = data:sub(pos, pos + llen - 1)
        pos = pos + llen

        arr[i] = {code = code, char = char}
    end

    return setmetatable({data = arr}, fastdict)
end

-- 二分查找下界
local function lower_bound(data, prefix)
    local l, r = 1, #data
    while l < r do
        local mid = (l + r) // 2
        if data[mid].code < prefix then
            l = mid + 1
        else
            r = mid
        end
    end
    return l
end

-- 二分查找上界
local function upper_bound(data, prefix)
    local hi = prefix .. "\255"
    local l, r = 1, #data
    while l < r do
        local mid = (l + r) // 2
        if data[mid].code <= hi then
            l = mid + 1
        else
            r = mid
        end
    end
    return l
end

-- 前缀查找
function fastdict:search(prefix, opts)
    local limit = opts and opts.limit
    local iter = opts and opts.iter or false
    local data = self.data
    local start_i = lower_bound(data, prefix)
    local cnt = 0
    if data[start_i].code:sub(1, #prefix) ~= prefix then
        return nil
    end

    if iter then
        local iter_i = start_i - 1
        return function ()
            if limit ~= nil then
                if cnt == limit then
                    return
                end
            end
            if data[iter_i + 1].code:sub(1, #prefix) == prefix then
                iter_i = iter_i + 1
                cnt = cnt + 1
                return cnt, data[iter_i].char
            end
        end
    end

    local end_i = upper_bound(data, prefix)
    local res = {}
    for i = start_i, end_i - 1 do
        table.insert(res, data[i].char)
        if limit ~= nil then
            if cnt >= limit then
                goto breakLoop
            end
            cnt = cnt + 1
        end
    end
    ::breakLoop::
    return res
end

return fastdict
