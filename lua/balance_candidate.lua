--[[
balance_candidate: 候选项重排序，使得单字与多字平衡
--]]

local function filter(input)
   local l = {}
   local s = {}
   local len = 0
   for cand in input:iter() do
      if (utf8.len(cand.text) == 1) then
     table.insert(s, cand)
      else
	 table.insert(l, cand)
      end
      len = len + 1
   end
   local li = 1
   local si = 1
   for var = 1, len do
       local index = var % 7
       if index == 0 then
           if li <= #l then
               s[si].comment = s[si].comment .. " >>"
           end
           yield(s[si])
           si = si + 1
           goto continue
       end
       if index > 5 or li > #l then
           yield(s[si])
           si = si + 1
        else
            yield(l[li])
            li = li + 1
       end
       ::continue::
   end
end

return filter
