local LIB_PREFIX = "/lib/"

local LIB_LINK_IDS = {}
LIB_LINK_IDS["log"] = "MhMVV6mY"
LIB_LINK_IDS["metatable"] = "TRRCk7WJ"
LIB_LINK_IDS["movement"] = "iYpJ9Gm7"
LIB_LINK_IDS["redstone_comms"] = "EKfAbcnh"
LIB_LINK_IDS["state_machine"] = nil

local function get_from_pastebin(name, path, force)
    if not fs.exists(path .. name) or force then
        print("[I] get_from_pastebin - " .. name)
        fs.delete(path .. name)
        os.run(
            {shell=shell},
            "/rom/programs/http/pastebin",
            "get", LIB_LINK_IDS[name], path .. name
        )
    end
    return fs.exists(path .. name)
end

function import(name)
    print("[I] import - starting")
    if get_from_pastebin(name, LIB_PREFIX, true) then
        print("[I] import - running")
        env = {}
        os.run(env, LIB_PREFIX .. name)
        return env["_export"]
    else
        return nil
    end
end