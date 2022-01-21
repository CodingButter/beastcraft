local pretty = require "cc.pretty"
local function switch(val, actions)
    local action = actions[val] or actions.default or function()
    end
    return action()
end

local table = {
    map = function(_tbl, f)
        local t = {}
        local i = 1
        if type(_tbl) == "table" then
            for k, v in pairs(_tbl) do
                t[i] = f(v, i, k)
                i = i + 1
            end
        end
        return t
    end,
    filter = function(_tbl, f)
        local t = {}
        local i = 1
        for k, v in pairs(_tbl) do
            if f(v, i, k) then
                t[i] = v;
                i = i + 1
            end
        end
        return t
    end
}

local function deepen(str, r)
    return (" "):rep(r) .. str
end

local function basicSerial(value, depth)
    depth = depth or 0
    if type(value) == "table" then
        local s = deepen("{\n", depth)
        for k, v in pairs(value) do
            s = s .. deepen("[" .. basicSerial(k, 0) .. "] = " .. basicSerial(v, depth + 2), depth + 2) .. "\n"
        end
        return s .. deepen("}", depth)
    elseif type(value) == "string" then
        return '"' .. value .. '"'
    elseif type(value) == "function" then
        return "function"
    end
    return tostring(value)
end

table.serialize = basicSerial

local debugger = peripheral.find "debugger" or term
if debugger then
    debugger.printTable = function(obj)
        debugger.print(table.serialize(obj))
    end
end
local monitor = peripheral.find "monitor"
if monitor then
    monitor.setTextScale(.5)
    term.redirect(monitor)
end
monitor = monitor or term.current()
local WIDTH, HEIGHT = term.getSize()
local window = window.create(term.current(), 1, 1, WIDTH, HEIGHT, true)
term.redirect(window)
return {
    switch = switch,
    table = table,
    debugger = debugger,
    window = window,
    monitor = monitor
}
