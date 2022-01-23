local listeners = require("beastcraft.managers.listeners")
listeners.triggerEvent({"render"})
local function startWorkLoop()
    local speed = .2
    for i = 1, 0, -speed do
        listeners.triggerEvent({"render"})
        os.startTimer(1)
        sleep(speed)
    end
    while true do
        local event = {os.pullEvent()}
        listeners.triggerEvent(event)
        listeners.triggerEvent({"render"})
        if event[1] == "timer" then
            listeners.triggerEvent({"render"})
            os.startTimer(1)
        end

    end
end
return {
    startWorkLoop = startWorkLoop
}

