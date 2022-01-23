local debugger = require(BEASTCRAFT_ROOT.."core.utils").debugger
local listeners = {}
local function triggerEvent(event)
    if event[1] ~= "render" and event[1]~="timer" then 
        debugger.printTable(event)
    end
    if listeners[event[1]] then
        for _, v in pairs(listeners[event[1]]) do
            v(event)
        end
    end
end
local function addEventListener(event, func)
    listeners[event] = listeners[event] or {}
    local listenerIndex = #listeners[event] + 1
    listeners[event][listenerIndex] = func
    return listenerIndex
end
local function removeEventListener(event, eventIndex)
    listeners[event][eventIndex] = nil
end
return {
    addEventListener = addEventListener,
    removeEventListener = removeEventListener,
    triggerEvent = triggerEvent
}
