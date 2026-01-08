local M = {}
local io = require("io")
local os = require("os")

function M.get_eth0_ips()
    local ips = {}
    local f = io.popen("ip -o -4 addr show dev eth0 | awk '{print $4}'")
    if not f then
        return ips
    end

    for line in f:lines() do
        local ip = line
        if ip then
            table.insert(ips, ip)
        end
    end

    f:close()
    return ips
end

M.get_eth0_ips()