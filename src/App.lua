local ui = require"beastcraft".ui

local App = function()
    local WIDTH, HEIGHT = term.getSize()
    return ui.div({
        id = "app",
        style = {
            top = 1,
            left = 1,
            width = WIDTH,
            height = HEIGHT,
            backgroundColor = colors.white
        },
        children = {ui.button({
            style = {
                width = 15,
                height = 3,
                backgroundColor = colors.gray,
                color = colors.white,
                top = 4,
                left = 0
            }
        }, "button")}
    })
end

return App

