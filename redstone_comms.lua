local import = import or _G["import"]

local log = import("log")
local LOG_LEVEL = LOG_LEVEL or _G["LOG_LEVEL"]

local mt = import("metatable")

local REDSTONE = mt.create_meta_table()
REDSTONE["OFF"] = 0
REDSTONE["READY"] = 1
REDSTONE["SYN"] = 2
REDSTONE["SYNACK"] = 3
REDSTONE["ACK"] = 4
REDSTONE["QUERY"] = 15

local function signal(side, type)
    log.debug("Signalling redstone " .. type .. " on ".. side)
    redstone.setAnalogOutput(side, REDSTONE[type])
end

local function timeout()
    sleep(5)
    return nil
end

local function pullevent()
    return os.pullEvent('redstone')
end

local function listen(side)
    log.debug("Waiting for redstone on ".. side)
    e = parallel.waitForAny(pullevent, timeout)
    log.debug(e)
    if e == 1 then -- waitForAny currently returns the arg number of the function that returned
        local rs = redstone.getAnalogInput(side)
        log.debug(rs)
        return REDSTONE[rs]
    else
        if side == "front" then
            log.debug("Trying to move forward")
            if not turtle.detect() then
                turtle.forward()
                return nil
            end
        end
    end
end

local function triple_handshake(side)
    signal(side, "SYN")
    for i=1,5 do
        response = listen(side)
        log.debug(response)
        if response == "SYN" then
            signal(side, "SYNACK")
        elseif response == "SYNACK" then
            signal(side, "ACK")
            sleep(0.2)
            signal(side, "OFF")
            return true
        elseif response == "ACK" then
            signal(side, "OFF")
            return true
        else
            signal(side, "SYN")
        end
    end
    return false
end

log.debug("Exporting redstone_comms")
_export = {triple_handshake=triple_handshake}