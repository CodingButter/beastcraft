local input = require"beastcraft".ui.input

local Input = function(props) -- Yeah we got props boys
    return input({
        style = {
            left = 2,
            top = 2,
            width = 16,
            height = 3,
            backgroundColor = colors.gray,
            color = colors.white,
            highlightColor = colors.lightGray,
            borderColor = colors.yellow
        }
    }, "Input")
end

return Input

