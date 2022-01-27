local button = require"beastcraft".ui.button
local state = require"beastcraft".state

local Button = function(props) -- Yeah we got props boys
    local pressed, setPressed = state.useState(false)
    local label = (props.type == "toggle" and pressed) and props.toggleLabel or props.label
    local togglePressed = function()
        setPressed(pressed == false)
    end
    props.style.backgroundColor = pressed and colors.lightGray or colors.gray
    props.style.color = colors.white
    props.style.highlightColor = pressed and colors.gray or colors.lightGray
    props.style.borderColor = colors.yellow
    local onClick = props.onClick or function()
    end
    local onRelease = props.onRelease or function()
    end
    props.onClick = function(self, event)
        if props.type == "toggle" then
            togglePressed()
        else
            setPressed(true)
        end
        onClick(self, event)
    end
    props.onRelease = function(self, event)
        if props.type ~= "toggle" then
            setPressed(false)
        end
        onRelease(self, event)
    end
    return button(props, label)
end

return Button

