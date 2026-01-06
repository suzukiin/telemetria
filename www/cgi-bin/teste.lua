#!/usr/bin/lua
local cjson = require "cjson"

local f = assert(io.open("../config.json", "rb"))
local s = f:read("*a"); f:close()
local t = cjson.decode(s)
print(t.name)