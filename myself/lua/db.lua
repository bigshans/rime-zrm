local reverseDbPool = {}
local levelDbPool = {}
local fastdictPool = {}

local fastdict = require "fastdict/fastdict"

local M = {}

function M.openLookup(schemaName)
    reverseDbPool[schemaName] = reverseDbPool[schemaName] or ReverseLookup(schemaName)
    local db = reverseDbPool[schemaName]
    return db
end

function M.openDb(dbname, isReadOnly)
    levelDbPool[dbname] = levelDbPool[dbname] or LevelDb(dbname)
    local db = levelDbPool[dbname]
    if db and not db:loaded() then
        if isReadOnly then
            db:open()
        else
            db:open_read_only()
        end
    end
    return db
end

function M.openFastDict(path)
    fastdictPool[path] = fastdictPool[path] or fastdict.load(path)
    return fastdictPool[path]
end

return M
