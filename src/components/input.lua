local input = require"beastcraft".ui.input
local debugger = require"beastcraft".utils.debugger
local state = require"beastcraft".state

local Input = function(props) -- Yeah we got props boys
    local label, setLabel = state.useState("")
    return input({
        id = "main-input",
        placeholder = "Input field",
        maxLength = 15,
        style = {
            left = 0,
            top = 3,
            width = math.max(16, #label + 5),
            height = 3,
            focusedBackgroundColor = colors.lightGray,
            backgroundColor = pressed and colors.lightGray or colors.gray,
            color = colors.white,
            highlightColor = pressed and colors.gray or colors.lightGray,
            borderColor = colors.yellow
        },
        onChange = function(self, value)
            setLabel(value)
        end,
        onClick = function(self, event)
        end,
        onRelease = function(self, event)
        end
    }, label)
end

return Input

