local div = require"beastcraft".ui.div
local Lobby = function(props)
    return div({
        style = {
            left = 3,
            width = 18,
            height = 10,
            top = 3,
            color = colors.white,
            backgroundColor = colors.gray,
            highlightColor = colors.lightGray,
            borderColor = colors.yellow
        }
    }, "Lobby")
end

return Lobby
