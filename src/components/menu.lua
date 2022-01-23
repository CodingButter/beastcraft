local div = require"beastcraft".ui.div

local Menu = function(props)
    return div({
        id = "toggle-menu",
        style = {
            width = 18,
            height = 10,
            left = 24,
            top = 3,
            display = props.showMenu and "block" or "none",
            backgroundColor = colors.gray,
            color = colors.white,
            highlightColor = colors.lightGray,
            borderColor = colors.yellow
        },
        onLostFocus = function(self, event)
            -- props.toggleMenu()
        end
    }, "Toggle menu")
end
return Menu
