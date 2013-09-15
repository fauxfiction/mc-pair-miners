function pulse_redstone(side, type)
  print("Pulsing redstone " .. type .. " on ".. side)
  redstone.setAnalogOutput(side, REDSTONE[type])
  sleep(0.1)
  redstone.setAnalogOutput(side, 0)
end

function expect_redstone(side, type)
  print("Waiting for redstone " .. type .. " on ".. side)
  local redstone_value = nil
  while redstone_value ~= REDSTONE[type] do
    os.pullEvent('redstone')
    redstone_value = redstone.getAnalogInput(side)
  end
end

function triple_handshake(side)
  pulse_redstone(side, "READY")
  expect_redstone(side, "READY")
  pulse_redstone(side, "READY")
end
