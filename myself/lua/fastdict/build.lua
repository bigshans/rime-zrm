-- build.lua
local infile = "./english.dict.yaml"
local outfile = "dict.bin"

-- 读入并排序
local entries = {}
for line in io.lines(infile) do
    local char, code = line:match("^(.-)\t(.-)$")
    if char and code then
        table.insert(entries, {code = code:lower(), char = char})
    end
end
table.sort(entries, function(a, b) return a.code < b.code end)

-- 写入二进制
local f = assert(io.open(outfile, "wb"))
local count = #entries
f:write(string.pack("<I4", count))  -- 小端 uint32

for _, e in ipairs(entries) do
    f:write(string.pack("<I2", #e.code))
    f:write(e.code)
    f:write(string.pack("<I2", #e.char))
    f:write(e.char)
end

f:close()
print("构建完成:", outfile, "共", count, "条记录")
