#!/usr/bin/lua
local jsonmod = require "json"
local os = require "os"
local io = require "io"

local equipment_json = jsonmod.sendEquipment()
local info_json = jsonmod.sendInfo()

for k, v in pairs(equipment_json) do
    local oids = v.OIDS
    for key, value in pairs(oids) do
        local cmd = "snmpget -v2c -c public " .. v.ip .. " " .. value.oid
        local pipe = io.popen(cmd)
        local output = pipe:read("*a")

        print(output)
        pipe:close()
    end
end
