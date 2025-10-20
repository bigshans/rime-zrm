local AuxFilter = {}

function AuxFilter.init(env)
    AuxFilter.aux_code = AuxFilter.readAuxTxt(env.name_space)

    local engine = env.engine
    local config = engine.schema.config

    -- 設定預設觸發鍵為分號，並從配置中讀取自訂的觸發鍵
    env.trigger_key = config:get_string("key_binder/aux_code_trigger") or ";"
    -- 设定是否显示辅助码，默认为显示
    env.show_aux_notice = config:get_string("key_binder/show_aux_notice") or 'true'
    if env.show_aux_notice == "false" then
        env.show_aux_notice = false
    else
        env.show_aux_notice = true
    end
end

function AuxFilter.readAuxTxt(txtpath)
    if AuxFilter.cache then
        return AuxFilter.cache
    end
    local defaultFile = 'ZRM_Aux-code_4.3.txt'
    local userPath = rime_api.get_user_data_dir() .. "/lua/"
    local fileAbsolutePath = userPath .. txtpath .. ".txt"

    local file = io.open(fileAbsolutePath, "r") or io.open(userPath .. defaultFile, "r")
    if not file then
        error("Unable to open auxiliary code file.")
        return {}
    end

    local auxCodes = {}
    for line in file:lines() do
        line = line:match("[^\r\n]+") -- 去掉換行符，不然 value 是帶著 \n 的
        local key, value = line:match("([^=]+)=(.+)") -- 分割 = 左右的變數
        if key and value then
            if auxCodes[key] then
                auxCodes[key] = auxCodes[key] .. " " .. value
            else
                auxCodes[key] = value
            end
        end
    end
    file:close()
    -- 確認 code 能打印出來
    -- for key, value in pairs(AuxFilter.aux_code) do
    --     log.info(key, table.concat(value, ','))
    -- end

    AuxFilter.cache = auxCodes
    return AuxFilter.cache
end

-- 輔助函數，用於獲取表格的所有鍵
local function table_keys(t)
    local keys = {}
    for key, _ in pairs(t) do
        table.insert(keys, key)
    end
    return keys
end

function AuxFilter.fullAux(env, word)
    local fullAuxCodes = {}
    for _, codePoint in utf8.codes(word) do
        local char = utf8.char(codePoint)
        local charAuxCodes = AuxFilter.aux_code[char] -- 每個字的輔助碼組
        if charAuxCodes then -- 輔助碼存在
            for code in charAuxCodes:gmatch("%S+") do
                for i = 1, #code do
                    fullAuxCodes[i] = fullAuxCodes[i] or {}
                    fullAuxCodes[i][code:sub(i, i)] = true
                end
            end
        end
    end

    -- 將表格轉換為字符串
    for i, chars in pairs(fullAuxCodes) do
        fullAuxCodes[i] = table.concat(table_keys(chars), "")
    end

    return fullAuxCodes
end


function AuxFilter.match(fullAux, auxStr)
    if #fullAux == 0 then
        return false
    end

    local firstKeyMatched = fullAux[1]:find(auxStr:sub(1, 1)) ~= nil
    -- 如果辅助码只有一个键，且第一个键匹配，则返回 true
    if #auxStr == 1 then
        return firstKeyMatched
    end

    -- 如果辅助码有两个或更多键，检查第二个键是否匹配
    local secondKeyMatched = fullAux[2] and fullAux[2]:find(auxStr:sub(2, 2)) ~= nil

    -- 只有当第一个键和第二个键都匹配时，才返回 true
    return firstKeyMatched and secondKeyMatched
end

function split(str,reps)
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function (w)
        table.insert(resultStrList,w)
    end)
    return resultStrList
end

function AuxFilter.func(input, env)
    local context = env.engine.context
    local inputCode = context.input
    if not string.find(inputCode, env.trigger_key) then
        for cand in input:iter() do
            yield(cand)
        end
        return
    end
    local words = split(inputCode, " ")
    for word in words:iter() do
    end
end
