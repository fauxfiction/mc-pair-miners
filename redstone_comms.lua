function redstone_pulse(side, type)
    print("Pulsing redstone " .. type .. " on ".. side)
    redstone.setAnalogOutput(side, REDSTONE[type])
    sleep(0.1)
    redstone.setAnalogOutput(side, 0)
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
    if e == 1 then -- waitForAny currently returns the arg number of the function that returned
        return REDSTONE[redstone.getAnalogInput(side)]
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
    redstone_pulse(side, "SYN")
    for i=1,5 do
        response = redstone_listen(side)
        if response == "SYN" then
            redstone_pulse(side, "SYNACK")
        elseif response == "SYNACK" then
            redstone_pulse(side, "ACK")
            return true
        elseif response == "ACK" then
            return true
        else
            redstone_pulse(side, "SYN")
        end
    end
    return false
end
