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

args = {...}
mine_forward(args[1])