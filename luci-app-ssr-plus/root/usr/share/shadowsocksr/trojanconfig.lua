local ucursor = require "luci.model.uci".cursor()
local json = require "luci.jsonc"
local server_section = arg[1]
local proto = arg[2] 
local local_port = arg[3]

local server = ucursor:get_all("shadowsocksr", server_section)

local trojan = {

    run_type = "nat",
    local_addr = "0.0.0.0",
    local_port = tonumber(local_port),
    remote_addr = server.server,
    remote_port = tonumber(server.server_port),
    password = {
       server.password
    },
    log_level =  1 ,
    ssl = {
        verify = true,
        verify_hostname = true,
        cert = (server.certificate == "1") and server.certpath or "",
        cipher = "TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256",
        sni = "",
        alpn = {
            "h2",
            "http/1.1"
        },
        reuse_session = true,
        session_ticket =  false,
        curves = ""
    },
    tcp = {
        no_delay = true,
        keep_alive = true,
        fast_open = (server.fast_open == "1") and true or false,
        fast_open_qlen = 20
    }
}

print(json.stringify(trojan, 1))
