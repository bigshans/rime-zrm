local db = require('db')
local log = require 'log'

local S = {}
local T = {}
local T2 = {}
local F = {}

local English="english"
local dict_bin = "/home/aerian/.local/share/fcitx5/rime/lua/fastdict/dict.bin"

-- | Check if @s is an English word.
--
-- @param s str
-- @return true if it can be considered an English word
local function str_is_english_word(s)
   return s:find(PAT_ENGLISH_WORD) ~= nil
end

function S.func(segs, env)
    local extDb = db.openFastDict(dict_bin)

    local cartpos = segs:get_current_start_position()

    local str = segs.input:sub(cartpos)
    str = string.gsub(str, ";", "")
    if #str < 3 then
        return true
    end
    local data = extDb:search(str, { iter = true, limit = 2 })
    local isMatch = data ~= nil
    if isMatch then
        local seg= Segment(cartpos, segs.input:len())
        seg.tags = Set({English})
        segs:add_segment(seg)
    end
    return true
end

function T.func(inp, seg, env)
    if seg:has_tag(English) then
        local extDb = db.openFastDict(dict_bin)
        local str = string.gsub(inp, ";", "")
        local data = extDb:search(str, { iter = true, limit = 2})
        if data ~= nil then
            for _, ch in data do
                local cand = Candidate(English, seg.start, seg._end, ch, "[english]")
                local shadow = ShadowCandidate(cand, cand.type, cand.text, cand.comment)
                yield(cand)
            end
        end
    end
end

function T2.init(env)
    env.english = Component.Translator(env.engine, "", "table_translator@english")
    env.limit_cnt = env.engine.schema.config:get_int('english/limit') or -1
end

function T2.func(inp, seg, env)
    local english_res = env.english:query(inp, seg)
    local limit = env.limit_cnt
    if english_res ~= nil then
        if limit == -1 then
            for cand in english_res:iter() do
                cand.comment = '[english]'
                yield(cand)
            end
        else
            local cnt = 1
            for cand in english_res:iter() do
                if cnt > limit then
                    break
                end
                cand.comment = '[english]'
                yield(cand)
                cnt = cnt + 1
            end
        end
    end
end

function F.func(t_input, env)
end


function T2.fini()
end

function S.init(env)
end

function S.fini(env)
end

function T.init(env)
end

function T.fini(env)
end

function F.init(env)
end

function F.fini(env)
end

return {
    Segment = S,
    Translator = T,
    Translator2 = T2,
    Filter = F,
}
