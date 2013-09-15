function create_meta_table()
    tbl = {}
    tbl.r_index = {}
    tbl.r_table = {}

    mt = {} -- Create the metatable
    mt.__newindex = function (self, key, value)
        if value == nil then
            if tonumber(key) then
                local i_value = self.r_index[key]
                self.r_index[key] = nil
                self.r_table[i_value] = nil
            else
                local t_value = self.r_table[key]
                self.r_index[t_value] = nil
                self.r_table[key] = nil
            end
        else
            if tonumber(key) then
                table.insert(self.r_index, tonumber(key), value)
                self.r_table[value] = key
            elseif tonumber(value) then
                self.r_table[key] = tonumber(value)
                table.insert(self.r_index, tonumber(value), key)
            else
                error("Bad assignment for metatable.")
            end
        end
    end

    mt.__index = function (self, key)
        if tonumber(key) then
            return (self.r_index[key])
        else
            return (self.r_table[key])
        end
    end

    setmetatable(tbl, mt)
    return tbl
end
