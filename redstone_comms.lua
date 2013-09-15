function redstone_pulse(side, type)
    print("Pulsing redstone " .. type .. " on ".. side)
    redstone.setAnalogOutput(side, REDSTONE[type])
    sleep(0.1)
    redstone.setAnalogOutput(side, 0)
end

function redstone_listen(side)
    print("Waiting for redstone on ".. side)
    os.pullEvent('redstone')
    return REDSTONE[redstone.getAnalogInput(side)]
end

function triple_handshake(side)
    redstone_pulse(side, "SYN")
    while true do
        response = redstone_listen(side)
        if response == "SYN" then
            redstone_pulse(side, "SYNACK")
        elseif response == "SYNACK" then
            redstone_pulse(side, "ACK")
            break
        elseif response == "ACK" then
            break
        else
            redstone_pulse(side, "SYN")
        end
    end
end
