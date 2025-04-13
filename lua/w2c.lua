-- 判断utf8字符byte长度
-- 0xxxxxxx - 1 byte
-- 110yxxxx - 192, 2 byte
-- 1110yyyy - 225, 3 byte
-- 11110zzz - 240, 4 byte
local function chsize(char)
    if not char then
        print("not char")
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end

local function my_split (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

-- 截取utf8 字符串
-- str:            要截取的字符串
-- startChar:    开始字符下标,从1开始
-- numChars:    要截取的字符长度
function utf8sub(str, startChar, numChars)

    local l = utf8.len(str)

    if startChar < 0 then
        startChar = l + 1 + startChar
    end

    if numChars == nil then
        numChars = l - startChar + 1
    elseif numChars < 0 then
        numChars = l - startChar + 1 + numChars
    end

    local startIndex = 1
    while startChar > 1 do
        local char = string.byte(str, startIndex)
        startIndex = startIndex + chsize(char)
        startChar = startChar - 1
    end

    local currentIndex = startIndex

    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + chsize(char)
        numChars = numChars -1
    end
    return str:sub(startIndex, currentIndex - 1)
end

local W2cFilter = {}

function W2cFilter.init(env)
    local engine = env.engine
    local config = engine.schema.config

    env.schema_name = config:get_string("schema/schema_id")
end

local function reverseLookup(env, word)
    local code_str = ReverseLookup(env.schema_name):lookup(word)
    if not code_str or code_str == "" then
        return nil
    end

    local code_list = my_split(code_str, " ")
    return my_split(code_list[1], ";")[2]
end

function W2cFilter.func(input, env)
    local valid = false
    local first_end = 1
    local splitter = "※" 
    for cand in input:iter() do
        local str = cand.text
        if utf8sub(str, -1) == splitter then
            str = utf8sub(str, 1, -1)
            valid = true
            first_end = cand._end
        end
        if valid and utf8.len(str) > 1 then
            for i = 1, utf8.len(str), 1 do
                local comment =' ?' .. str
                local word = utf8sub(str, i, 1)
                local auxCode = reverseLookup(env, word)
                print(auxCode)
                if auxCode ~= nil then
                    comment = comment .. ";" .. auxCode
                end
                -- 结束范围必须为到分割点为止索引范围
                yield(Candidate("w2c", cand.start, first_end, word, comment))
            end
        else
            yield(cand)
        end
       ::continue::
    end
end

return W2cFilter 
