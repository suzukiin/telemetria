-- adiciona ../lib ao package.path
package.path = package.path .. ";../lib/?.lua"

local bootstrap = require "bootstrap"
local vpn = require "vpn"
local lte = require "lte"

bootstrap.json_header()

local vpn_status, vpn_ip = vpn.get_status()
local rssi = lte.get_rssi()

print(string.format([[
{
  "vpn": {
    "status": "%s",
    "ip": %s
  },
  "lte": {
    "rssi": %s
  }
}
]],
    vpn_status,
    vpn_ip and '"' .. vpn_ip .. '"' or "null",
    rssi or "null"
))
