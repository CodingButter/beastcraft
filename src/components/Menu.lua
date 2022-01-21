local div = require"beastcraft".ui.div

local Menu = function(props)
    return div({
        style = {
            width = 18,
            height = 10,
            left = 22,
            top = 2,
            display = props.showMenu and "block" or "none",
            backgroundColor = colors.gray,
            color = colors.white,
            highlightColor = colors.lightGray,
            borderColor = colors.yellow
        }
    }, "Toggle menu")
end
return Menu
