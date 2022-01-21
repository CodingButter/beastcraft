local button = require"beastcraft".ui.button
local state = require"beastcraft".state
local MenuContext = require "src.context.MenuContext"

local Button = function(props) -- Yeah we got props boys
    local pressed, setPressed = state.useState(false)
    local menuState, toggleMenu = table.unpack(state.useContext(MenuContext))
    return button({
        style = {
            left = 5,
            top = 5,
            width = 16,
            height = 3,
            backgroundColor = pressed and colors.lightGray or colors.gray,
            color = colors.white,
            highlightColor = pressed and colors.gray or colors.lightGray,
            borderColor = colors.yellow
        },
        onClick = function(self, event)
            setPressed(true)
            toggleMenu()
        end,
        onRelease = function(self, event)
            setPressed(false)
        end
    }, "Menu " .. (menuState and "Opened" or "Closed"))
end

return Button

