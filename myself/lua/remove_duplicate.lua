--[[
remove_duplicate: 去除重复项
--]]

local function addToSet(set, key)
    set[key] = true
end

local function removeFromSet(set, key)
    set[key] = nil
end

local function setContains(set, key)
    return set[key] ~= nil
end

local function filter(input)
    local t = {}
   for cand in input:iter() do
      if t[cand.text] == nil then
          addToSet(t, cand.text)
          yield(cand)
      end
   end
end

return filter
