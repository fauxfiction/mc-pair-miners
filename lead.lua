function mine_forward()
    length = state["directive"]["x"] + 0
    if state["progress"]["x"] >= length then
        state["progress"]["x"] = 1
    end
    print("Starting miner for "..length.." block")

    turtle.select(16)
    turtle.refuel()
    if turtle.getFuelLevel() <= length*3 then
        error("Insufficient fuel to mine "..length.." blocks", 0)
    end

    for i=state["progress"]["x"],length do
        if not triple_handshake("back") then
            return false
        end

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

        if not triple_handshake("back") then
            return false
        end
        turtle.dig()
        turtle.forward()
        state["progress"]["x"] = state["progress"]["x"] + 1
        print("Progress: x="..state["progress"]["x"])
        save_state(state)
    end
    return true
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

function get_state()
    if fs.exists("_state") then
        print("From file")
        f = fs.open("_state", "r")
        state = textutils.unserialize(f.readAll())
        f.close()

        if args[1] ~= "recover" then
            state["directive"] = {["x"]=args[1], ["y"]=args[2] or 1}
        end
    else
        state = {}
        state["role"] = "lead"
        state["tasked"] = true
        state["directive"] = {["x"]=args[1], ["y"]=args[2] or 1}
        state["progress"] = {["x"]=1, ["y"]=1}
        state["zoffset"] = 0
    end
    return state
end

function save_state(state)
    f = fs.open("_state", "w")
    f.write(textutils.serialize(state))
    f.close()
end

-- Mainline
args = {...}

if not args[1] then
    error("\nUsage: script_name <length|'recover'> [width]")
end

state = get_state()

for i=1,state["directive"]["y"] do

    if mine_forward(state["directive"]["x"]) then
        if state["progress"]["y"] % 2 == 1 then
            next_turn = "left"
        else
            next_turn = "right"
        end
        turn(next_turn, 2)
        state["progress"]["y"] = state["progress"]["y"] + 1
        print("Progress: y="..state["progress"]["y"])
        save_state(state)
    else
        print("Lost follower! I'm going to stop here.")
        return false
    end
    
end

state["tasked"] = false
