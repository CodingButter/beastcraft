local ui = require"beastcraft".ui

local App = function()
    return ui.div({
        id = "app",
        style = {
            top = 2,
            left = 2,
            width = 5,
            height = 5,
            backgroundColor = colors.blue
        },
        children = {ui.button({}, "button")}
    })
end

return App

