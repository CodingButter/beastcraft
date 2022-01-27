local state = require"beastcraft".state
local Button = require "src.components.button"
local div = require"beastcraft".ui.div
local monitor = require"beastcraft".utils.monitor
local roomContext = require"src.hooks.usep2p".roomContext
local lobby = require"src.hooks.usep2p".lobby
local p2pContext = require"src.hooks.usep2p".p2pContext
local routerContext = require"beastcraft".routerContext
local debugger = require"beastcraft".utils.debugger

local LobbyButton = function()
    local WIDTH, HEIGHT = monitor.getSize()
    local page, setPage = table.unpack(state.useContext(routerContext))
    local p2p = state.useContext(p2pContext)
    local roomctx = state.useContext(roomContext)
    return Button({
        id = "lobby-btn",
        label = "Lobby",
        style = {
            left = WIDTH / 2 - 8 - 2,
            top = HEIGHT - 8,
            width = 16,
            height = 3
        },
        onClick = function(self, event)
            roomctx.setRoomList(p2p.getRooms(lobby))
            setPage("Lobby")
        end
    })
end

local Description = function()
    local WIDTH, HEIGHT = monitor.getSize()
    return div({
        id = "description-background",
        style = {
            backgroundColor = colors.yellow,
            highlightColor = colors.yellow,
            borderColor = colors.lightGray,
            color = colors.gray,
            width = 24,
            top = 3,
            left = WIDTH - WIDTH / 3 - 16,
            height = 4
        }
    }, "    This is a\nChat Application")
end

return {
    Description = Description,
    LobbyButton = LobbyButton
}
