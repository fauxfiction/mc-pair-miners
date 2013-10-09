if fs.exists("_state") then
    f = fs.open("_state", "r")
    local state = textutils.unserialize(f.readAll())
    f.close()

    if state["tasked"] then
        shell.run("launcher "..state["role"].." recover")
    end
end