local state = require"beastcraft".state
local div = require"beastcraft".ui.div
local monitor = require"beastcraft".utils.monitor
local p2pContext = require"src.hooks.usep2p".p2pContext
local roomContext = require"src.hooks.usep2p".roomContext
local utils = require"beastcraft".utils
local NewRoom = function(props)
    local WIDTH, HEIGHT = monitor.getSize()
    local p2p = state.useContext(p2pContext)
    local roomctx = state.useContext(roomContext)
    return div({
        id = "new-room-background",
        style = {
            left = 1,
            width = WIDTH - 2,
            height = HEIGHT - 2,
            top = 1,
            color = colors.white,
            backgroundColor = colors.gray,
            highlightColor = colors.lightGray,
            borderColor = colors.yellow
        }
    }, roomctx.room)
end

return NewRoom
