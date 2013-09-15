-- Bootstrap script for pair miners
local VERSION = "alpha"

-- This script makes the following assumptions:
--  * A mining turtle will lead and should have a chunk loader module.
--  * An engineering turtle will follow and should have a wireless modem.
--  * The leader will have a mining well in slot 1.
--  * The follower will have an item tesseract in slot 1 and an energy tesseract in slot 2.
--  * Both turtles will have fuel in slot 16 which will be consumed upon starting a run.
--  * Tesseracts used by the follower must be preconfigured using pulverised shiny metal.

-- TODO:
--  * Make launcher robust for startup use
--  * Change Redstone message protocol to handle triple handshake better (SYN, SYNACK, ACK)
--  * State recovery on startup (chunk loading/desync issues)
--  * Fuel use on as as needed basis (store in slot 15?)
--  * 2 dimensional mining directives

-- Pastebin codes
local pastebin = {}
pastebin["launcher"] = "whDW3XJG"
pastebin["lead"] = "LDuvasMW"
pastebin["follow"] = "eEjhpYeV"
pastebin["turn"] = "iYpJ9Gm7"
pastebin["metatable"] = "TRRCk7WJ"
pastebin["redstone_comms"] = "EKfAbcnh"

function get_from_pastebin(name)
    fs.delete(name)
    return shell.run("rom/programs/http/pastebin get " .. pastebin[name] .. " " .. name)
end

-- Run prerequisite scripts
function require(name)
    get_from_pastebin(name)
    shell.run(name)
end
require("metatable")
require("redstone_comms")

-- Globals
REDSTONE = create_meta_table()
REDSTONE["READY"] = 1
REDSTONE["SYN"] = 2
REDSTONE["SYNACK"] = 3
REDSTONE["ACK"] = 4
REDSTONE["QUERY"] = 15

-- Mainline
args = {...}
if args[1] == "forceupdate" then
    print("Updating the launcher")
    return get_from_pastebin("launcher")
end

-- Check if we need to lead or follow
role = args[1]
distance = args[2] or ""
width = args[3] or ""
if role == "lead" then
    if get_from_pastebin("lead") then
        return shell.run("lead " .. distance .. " " .. width)
    end
elseif role == "follow" then
    if get_from_pastebin("follow") then
        return shell.run("follow " .. distance .. " " .. width)
    end
else
    error("Usage Error:\nThe mining launcher must be told to 'lead' or 'follow'.\nUsage: script_name <lead|follow> length [width]")
end

-- Return true in case the launcher was called programmatically
return true
