function redstone_signal(side, type)
    print("Signalling redstone " .. type .. " on ".. side)
    redstone.setAnalogOutput(side, REDSTONE[type])
end

function redstone_timeout()
    sleep(5)
    return nil
end

function redstone_pullevent()
    return os.pullEvent('redstone')
end

function redstone_listen(side)
    print("Waiting for redstone on ".. side)
    e = parallel.waitForAny(redstone_pullevent, redstone_timeout)
    print(e)
    if e == 1 then -- waitForAny currently returns the arg number of the function that returned
        local rs = redstone.getAnalogInput(side)
        print(rs)
        return REDSTONE[rs]
    else
        if side == "front" then
            print("Trying to move forward")
            if not turtle.detect() then
                turtle.forward()
                return nil
            end
        end
    end
end

function triple_handshake(side)
    redstone_signal(side, "SYN")
    for i=1,5 do
        response = redstone_listen(side)
        print(response)
        if response == "SYN" then
            redstone_signal(side, "SYNACK")
        elseif response == "SYNACK" then
            redstone_signal(side, "ACK")
            sleep(0.2)
            redstone_signal(side, "OFF")
            return true
        elseif response == "ACK" then
            redstone_signal(side, "OFF")
            return true
        else
            redstone_signal(side, "SYN")
        end
    end
    return false
end
