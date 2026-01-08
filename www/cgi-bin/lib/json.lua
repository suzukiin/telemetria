#!/usr/bin/lua
local cjson = require "cjson"

local M = {}

function M.getInfo()
    local f, err = io.open("/www/config.json", "r")
    if not f then
        return nil, "erro ao abrir config.json: " .. (err or "desconhecido")
    end

    local content = f:read("*a")
    f:close()

    local data, perr = cjson.decode(content)
    if not data then
        return nil, "erro ao decodificar JSON: " .. (perr or "desconhecido")
    end

    return data.info
end

return M
