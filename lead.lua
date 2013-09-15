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

args = {...}
mine_forward(args[1])
