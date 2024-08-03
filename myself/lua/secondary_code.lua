-- 自然码辅码保留

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

local function filter(input)
   for cand in input:iter() do
       local comment = cand.comment
       if utf8.len(comment) == 0 then
           yield(cand)
           goto continue
       end
       local sp = my_split(comment, ";")
       if #sp <= 1 then
           yield(cand)
           goto continue
       end
       local prefix = my_split(sp[1], "%s")
       table.remove(prefix, #prefix)
       cand.comment = ";" .. sp[2]
       yield(cand)
       ::continue::
   end
end

return filter
