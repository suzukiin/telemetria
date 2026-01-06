#!/usr/bin/lua
local cjson = require "cjson"

local f = assert(io.open("../config.json", "rb"))
local s = f:read("*a"); f:close()
local t = cjson.decode(s)

local function sendEquipment()
    return t.devices
end

local function sendInfo()
    return t.info
end

return { sendEquipment = sendEquipment, sendInfo = sendInfo }