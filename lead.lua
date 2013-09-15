function mine_forward()
    length = state["directive"]["x"]
    state["progress"]["x"] = 0
    print("Starting miner for "..length.." block")

    turtle.select(16)
    turtle.refuel()
    if turtle.getFuelLevel() <= length*3 then
        error("Insufficient fuel to mine "..length.." blocks", 0)
    end

    for i=1,length do
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
        state["progress"]["x"] = state["progress"]["x"] + 1
        print("Progress: x="..state["progress"]["x"])
    end
end

function turn(direction, count)
    for i=1,count do
        if direction == 'left' then
            turtle.turnLeft()
        elseif direction == 'right' then
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

if not args[1] then
    error("\nUsage: script_name length [width]")
end

if fs.exists("_state") then
    print("From file")
    f = fs.open("_state", "r")
    state = textutils.unserialize(f.readAll())
    f.close()
else
    state = {}
    state["role"] = "lead"
    state["directive"] = {["x"]=args[1], ["y"]=args[2] or 1}
    state["progress"] = {["x"]=0, ["y"]=0}
    state["zoffset"] = 0
end

for i=1,state["directive"]["y"] do
    mine_forward(state["directive"]["x"])

    if state["progress"]["y"] % 2 == 1 then
        next_turn = 'left'
    else
        next_turn = 'right'
    end
    turn(next_turn, 2)
    state["progress"]["y"] = state["progress"]["y"] + 1
    print("Progress: y="..state["progress"]["y"])
end

f = fs.open("_state", "w")
f.write(textutils.serialize(state))
f.close()
