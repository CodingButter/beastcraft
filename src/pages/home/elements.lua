local state = require"beastcraft".state
local Button = require "src.components.button"
local div = require"beastcraft".ui.div
local monitor = require"beastcraft".utils.monitor
local routerContext = require"beastcraft".routerContext
local LobbyButton = function()
    local WIDTH, HEIGHT = monitor.getSize()
    local page, setPage = table.unpack(state.useContext(routerContext))
    return Button({
        label = "Lobby",
        style = {
            left = WIDTH / 2 - 8 - 2,
            top = HEIGHT - 8,
            width = 16,
            height = 3
        },
        onClick = function(self, event)
            setPage("Lobby")
        end
    })
end

local Description = function()
    local WIDTH, HEIGHT = monitor.getSize()
    return div({
        style = {
            backgroundColor = colors.yellow,
            highlightColor = colors.yellow,
            borderColor = colors.lightGray,
            color = colors.gray,
            width = 24,
            top = 2,
            left = WIDTH - WIDTH / 3 - 16,
            height = 4
        }
    }, "    This is a\nChat Application")
end

return {
    Description = Description,
    LobbyButton = LobbyButton
}
