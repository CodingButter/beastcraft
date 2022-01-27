local div = require"beastcraft".ui.div
local Button = require "src.components.button"
local ListItem = function(props)
    return Button({
        style = props.style,
        children = {div({
            style = {
                top = 2,
                width = props.style.width,
                height = 1,
                color = colors.white
            }
        }, ("\131"):rep(props.style.width))}
    })
end

return ListItem

--[[
      list - div
            item - button
                  border-under button
]]
