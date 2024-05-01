--- 将表情等特殊符号排到后面

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

EXP = false

local function translator(input, seg, env)
    local sp = my_split(input, ";")
    if #sp >= 1 then
        if sp[1] == 'be' or sp[1] == 'fe' then
            EXP = true
            return
        end
    end
    EXP = false
end

local function filter(input, env)
    local emoji = {}
    local other = {}
    for cand in input:iter() do
        local comment = cand.comment
        local sp = my_split(comment, ';')
        if sp[1] == 'be' or sp[1] == 'fe' then
            table.insert(emoji, cand)
        else
            table.insert(other, cand)
        end
    end
    for i = 1, #other do
        yield(other[i])
    end
    if EXP then
        for i = 1, #emoji do
            yield(emoji[i])
        end
    end
end

return {
    filter,
    translator
}
