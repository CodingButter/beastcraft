local state = require"beastcraft".state
local div = require"beastcraft".ui.div
local LobbyButton = require"src.pages.home.elements".LobbyButton
local Description = require"src.pages.home.elements".Description
local monitor = require"beastcraft".utils.monitor
local Home = function(props)
    local WIDTH, HEIGHT = monitor.getSize()

    return div({
        style = {
            width = WIDTH - 4,
            height = HEIGHT - 4,
            top = 2,
            left = 2,
            color = colors.white,
            backgroundColor = colors.gray,
            highlightColor = colors.lightGray,
            borderColor = colors.yellow
        },
        children = {LobbyButton(), Description()}
    }, "Home Page")
end

return Home
