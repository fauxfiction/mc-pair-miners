function dig_forward()
  turtle.dig()
  turtle.forward()
  turtle.digDown()
end

function turn_left()
  turtle.turnLeft()
  dig_forward()
end

function turn_right()
  turtle.turnRight()
  dig_forward()
end

args = {...}
if not args[1] then
  error("I need a direction!")
end
if not args[2] then
  count = 1
else
  count = args[2]
end

for i=1,count do
  if args[1] == 'l' then
    turn_left()
  elseif args[1] == 'r' then
    turn_right()
  else
    error("Bad direction code")
  end
end
