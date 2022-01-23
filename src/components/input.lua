local input = require"beastcraft".ui.input

local state = require"beastcraft".state

local Input = function(props) -- Yeah we got props boys
    local label, setLabel = state.useState("Type Here")
    return input({
        style = {
            left = 0,
            top = 0,
            width = 16,
            height = 3,
            backgroundColor = pressed and colors.lightGray or colors.gray,
            color = colors.white,
            highlightColor = pressed and colors.gray or colors.lightGray,
            borderColor = colors.yellow
        },
        onFocus = function(self, event)
            setLabel("")
        end,
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

