local function get_log_funcs()

    local LOG_LEVELS = {}
    LOG_LEVELS["CRITICAL"] = 5
    LOG_LEVELS["ERROR"] = 4
    LOG_LEVELS["WARNING"] = 3
    LOG_LEVELS["INFO"] = 2
    LOG_LEVELS["DEBUG"] = 1
    LOG_LEVELS["NULL"] = 0

    local function log_wrapper(level)
        local function log_inner(msg)
            local global = LOG_LEVELS[LOG_LEVEL] or LOG_LEVELS["INFO"]
            if ( LOG_LEVELS[level] >= global and
                 msg and msg ~= "" ) then
                print("["..string.sub(level,1,1).."] " .. msg)
            end
        end
        return log_inner
    end

    local log_funcs = {}
    log_funcs.critical = log_wrapper("CRITICAL")
    log_funcs.error = log_wrapper("ERROR")
    log_funcs.warning = log_wrapper("WARNING")
    log_funcs.info = log_wrapper("INFO")
    log_funcs.debug = log_wrapper("DEBUG")
    log_funcs.null = log_wrapper("NULL")

    return log_funcs
end

_export = get_log_funcs()