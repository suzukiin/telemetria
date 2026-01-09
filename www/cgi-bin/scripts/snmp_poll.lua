package.path = package.path .. ";../lib/?.lua"

local json = require "json"
local snmp = require "snmp"
local cjson = require "cjson"

local INTERVAL = 10 -- segundos entre polls

local function poll()
    local devices = json.getDevices()
    if not devices then return end

    for _, device in ipairs(devices) do
        for _, oid in ipairs(device.OIDS) do
            local value = snmp.getOid(oid.oid, device.ip)

            if value then
                local payload

                if oid.type == "boolean" then
                    local clean = value:match("(%d+)")
                    payload = oid.enum and oid.enum[clean] or "N/A"

                elseif oid.type == "integer" then
                    local clean = value:match("(%-?%d+)")
                    if clean then
                        if oid.mask then
                            payload = tonumber(clean) * oid.mask
                        else
                            payload = tonumber(clean)
                        end
                    end
                end

                if payload then
                    local msg = {
                        ip = device.ip,
                        oid = oid.oid,
                        topic = oid.topic,
                        value = payload,
                        unit = oid.unit
                    }

                    print(cjson.encode(msg))
                    -- aqui depois entra MQTT, log, banco etc
                end
            end
        end
    end
end

-- daemon loop
while true do
    poll()
    os.execute("sleep " .. INTERVAL)
end
