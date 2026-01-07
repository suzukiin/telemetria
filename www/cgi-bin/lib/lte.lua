local M = {}
local io = require "io"
local os = require "os"

local DEV = "/dev/ttyUSB1"

local function open_port()
    local f = io.open(DEV, "r+")
    if not f then return nil end
    f:setvbuf("no")
    return f
end

local function send_at(f, cmd, timeout)
    f:write(cmd .. "\r")
    f:flush()

    local deadline = os.time() + (timeout or 2)
    local lines = {}

    while os.time() < deadline do
        local line = f:read("*l")
        if line then
            -- debug opcional
            -- print("RX:", line)

            table.insert(lines, line)

            if line == "OK" or line:match("ERROR") then
                break
            end
        end
    end

    return lines
end

function M.get_rssi()
    local f = open_port()
    if not f then
        return nil
    end

    -- desliga eco
    send_at(f, "ATE0")

    -- comando RSSI
    local resp = send_at(f, "AT+CSQ")

    f:close()

    for _, line in ipairs(resp) do
        local rssi = line:match("%+CSQ:%s*(%d+),")
        if rssi and rssi ~= "99" then
            return -113 + (tonumber(rssi) * 2)
        end
    end

    return nil
end

return M
