local listeners = require(BEASTCRAFT_ROOT .. "managers.listeners")
listeners.triggerEvent({"render"})
local function startWorkLoop()
    local speed = .33
    for i = 1, 0, -speed do
        os.startTimer(1)
        sleep(speed)
    end
    while true do
        local event = {os.pullEvent()}
        listeners.triggerEvent(event)
        if event[1] == "timer" then
            listeners.triggerEvent({"render"})
            os.startTimer(1)
        end

    end
end
return {
    startWorkLoop = startWorkLoop
}

