local M = {}
local io = require "io"

function M.get_ip()
    local pipe = io.popen("tailscale ip -4 2>/dev/null")
    if not pipe then return nil end

    local ip = pipe:read("*l")
    pipe:close()

    if ip and ip ~= "" then
        return ip
    end

    return nil
end

function M.get_status()
    local ip = M.get_ip()
    if ip then
        return "up", ip
    end
    return "down", nil
end

return M
