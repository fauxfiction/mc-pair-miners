local IMPORT_LINK_ID = "ME7waTv3"
local LIB_PREFIX = "/lib/"
local APP_PREFIX = "/miner/"

fs.makeDir(LIB_PREFIX)
assert(fs.isDir(LIB_PREFIX) and not fs.isReadOnly(LIB_PREFIX))
fs.delete(LIB_PREFIX .. "import")

shell.run(
    "rom/programs/http/pastebin get " .. IMPORT_LINK_ID ..
    " " .. LIB_PREFIX .. "import"
)

env = {shell=shell}
os.run(env, LIB_PREFIX .. "import")
-- Export 'import' for global use
import = env['import']
_G["import"] = import

LOG_LEVEL = "DEBUG"
_G["LOG_LEVEL"] = "DEBUG"

rc = import("redstone_comms")
sm = import("state_machine")
