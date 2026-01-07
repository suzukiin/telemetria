#!/usr/bin/lua

local cjson = require "cjson"

-- cabeçalho HTTP (se for CGI)
print("Content-Type: application/json\n")

-- lê o JSON
local f = io.open("/home/lucas/overlay/www/config.json", "r")
local content = f:read("*a")
f:close()

-- decodifica
local data = cjson.decode(content)

print(cjson.encode(data.info))
