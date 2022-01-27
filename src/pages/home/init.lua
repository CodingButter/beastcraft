local state = require"beastcraft".state
local div = require"beastcraft".ui.div
local LobbyButton = require"src.pages.home.elements".LobbyButton
local Description = require"src.pages.home.elements".Description
local monitor = require"beastcraft".utils.monitor
local Home = function(props)
    local WIDTH, HEIGHT = monitor.getSize()

    return div({
        id = "home-background-div",
        style = {
            width = WIDTH - 2,
            height = HEIGHT - 2,
            top = 1,
            left = 1,
            color = colors.white,
            backgroundColor = colors.gray,
            highlightColor = colors.lightGray,
            borderColor = colors.yellow
        },
        children = {LobbyButton(), Description()}
    }, "Home Page")
end

return Home
