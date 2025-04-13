-- 自然码辅码保留

local function my_split(inputstr, sep)
    if sep == nil then
        sep = '%s'
    end
    local t = {}
    for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
        table.insert(t, str)
    end
    return t
end

local SecondaryFilter = {}

function SecondaryFilter.init(env)
    local engine = env.engine
    local config = engine.schema.config

    env.schema_name = config:get_string('schema/schema_id')
end

local function reverseLookup(env, word)
    local code_str = ReverseLookup(env.schema_name):lookup(word)
    if not code_str or code_str == '' then
        return nil
    end

    local code_list = my_split(code_str, ' ')
    local c = my_split(code_list[1], ';')
    if #c == 1 then
        return c[1]
    end
    return c[2]
end

function SecondaryFilter.func(input, env)
    print('---------------')
    for cand in input:iter() do
        print('type', cand.text, cand:get_dynamic_type())
        if cand:get_dynamic_type() == 'Simple' then
            yield(cand)
            goto continue
        end
        local codeComment = cand.comment
        local comment = cand.comment
        if utf8.len(cand.text) >= 2 or utf8.len(comment) == 0 then
            local auxCodes = {}
            local buffer = ''

            -- 判断一个字符是否为中文（CJK Unified Ideographs 范围）
            local function isChineseChar(ch)
                local code = utf8.codepoint(ch)
                return (code >= 0x4E00 and code <= 0x9FFF)
                    or (code >= 0x3400 and code <= 0x4DBF) -- 扩展A
                    or (code >= 0x20000 and code <= 0x2A6DF) -- 扩展B
                    or (code >= 0x2A700 and code <= 0x2B73F) -- 扩展C
                    or (code >= 0x2B740 and code <= 0x2B81F) -- 扩展D
                    or (code >= 0x2B820 and code <= 0x2CEAF) -- 扩展E
            end

            for _, c in utf8.codes(cand.text) do
                local ch = utf8.char(c)
                local code = reverseLookup(env, ch)

                if code then
                    -- 之前的 buffer 要先放进去
                    if buffer ~= '' then
                        table.insert(auxCodes, buffer)
                        buffer = ''
                    end
                    table.insert(auxCodes, code)
                else
                    if isChineseChar(ch) then
                        -- 遇到中文，但 reverseLookup 没返回编码
                        if buffer ~= '' then
                            table.insert(auxCodes, buffer)
                            buffer = ''
                        end
                        table.insert(auxCodes, ch)
                    else
                        -- 是非中文字符，缓存起来
                        buffer = buffer .. ch
                    end
                end
            end

            -- 把最后的 buffer 放进去
            if buffer ~= '' then
                table.insert(auxCodes, buffer)
            end

            local aux_str = auxCodes[1]
            -- 拼接最终结果
            if #auxCodes ~= 1 then
                aux_str = table.concat(auxCodes, ',')
            end
            if aux_str ~= cand.text then
                codeComment = ';' .. aux_str
            end
        else
            if utf8.len(comment) == 0 then
                yield(cand)
                goto continue
            end
            -- print(cand.text, comment)
            local sp = my_split(comment, ';')
            if #sp <= 1 then
                yield(cand)
                goto continue
            end
            local prefix = my_split(sp[1], '%s')
            table.remove(prefix, #prefix)
            if not noAux then
                codeComment = ';' .. sp[2]
            end
        end

        -- 處理 simplifier
        if cand:get_dynamic_type() == 'Shadow' then
            local shadowText = cand.text
            local originalCand = cand:get_genuine()
            cand = ShadowCandidate(originalCand, originalCand.type, shadowText, codeComment)
        else
            cand.comment = codeComment
        end
        yield(cand)
        ::continue::
    end
end

function SecondaryFilter.fini(env) end

return SecondaryFilter
