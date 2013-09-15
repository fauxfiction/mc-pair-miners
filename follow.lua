function mine_forward(distance)
    if not distance then
        error("Usage: script_name distance")
    end
    print("Starting tess for "..distance.." block")

    turtle.select(16)
    turtle.refuel()
    if turtle.getFuelLevel() <= distance*1 then
        error("Insufficient fuel to mine "..distance.." blocks", 0)
    end

    for i=1,distance do
        triple_handshake('front')

        while turtle.detect() do
            sleep(0.1)
        end

        turtle.select(1)
        turtle.place()
        turtle.select(2)
        turtle.placeDown()
        sleep(5)

        turtle.digDown()
        turtle.select(1)
        turtle.dig()

        triple_handshake('front')
        while turtle.detect() do
            sleep(0.1)
        end
        turtle.forward()
    end
end

function turn(direction, count)
    for i=1,count do
        while turtle.detect() do
            sleep(0.5)
        end
        turtle.forward()
        if direction == 'l' then
            turtle.turnLeft()
        elseif direction == 'r' then
            turtle.turnRight()
        else
            return false
        end
    end
end

--- Mainline
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
