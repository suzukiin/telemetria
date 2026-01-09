local M = {}
local os = require "os"

function M.getOid(oid, ip)
    local f = io.popen("snmpget -v2c -c public " .. ip .. " " .. oid)
    if not f then
        return nil
    end

    local output = f:read("*a")
    f:close()

    local value = output:match("= .-: (.+)")
    return value
end

return M