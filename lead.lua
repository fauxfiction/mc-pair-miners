function mine_forward(distance)
    if not distance then
        error("Usage: script_name distance")
    end
    print("Starting miner for "..distance.." block")

    turtle.select(16)
    turtle.refuel()
    if turtle.getFuelLevel() <= distance*3 then
        error("Insufficient fuel to mine "..distance.." blocks", 0)
    end

    for i=1,distance do
        triple_handshake('back')

        turtle.digUp()
        turtle.digDown()
        turtle.select(1)
        turtle.placeDown()
        turtle.up()

        sleep(5)

        while turtle.detectDown() do
            sleep(0.1)
        end

        turtle.down()
        turtle.digDown()

        triple_handshake('back')
        turtle.dig()
        turtle.forward()
    end
end

function turn(direction, count)
    for i=1,count do
        if direction == 'l' then
            turtle.turnLeft()
        elseif direction == 'r' then
            turtle.turnRight()
        else
            return false
        end
        turtle.dig()
        turtle.forward()
        turtle.digDown()
    end
end

-- Mainline
args = {...}

if fs.exists("_state") then
    print("From file")
    f = fs.open("_state", "r")
    state = textutils.unserialize(f.readAll())
    f.close()
else
    state = {}
    state["role"] = "follow"
    state["distance"] = args[1]
    state["progress"] = 0
    state["zoffset"] = 0
    state["nextturn"] = 'r'
end

mine_forward(args[1])

turn(state["nextturn"], 2)
if state["nextturn"] == 'r' then
    state["nextturn"] = 'l'
else
    state["nextturn"] = 'r'
end

f = fs.open("_state", "w")
f.write(textutils.serialize(state))
f.close()
