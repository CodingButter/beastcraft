local div = require"beastcraft".ui.div
local state = require"beastcraft".state
local monitor = require"beastcraft".utils.monitor
local Button = require "src.components.Button"
local MenuContext = require "src.context.MenuContext"

local App = function()
    local WIDTH, HEIGHT = monitor.getSize()
    local showMenu, setShowMenu = state.useState(false)

    local toggleMenu = function()
        setShowMenu(showMenu == false)
    end

    return div({
        style = {
            top = 1,
            left = 1,
            width = WIDTH,
            height = HEIGHT,
            backgroundColor = colors.blue
        },
        children = MenuContext:Provider({
            value = {showMenu, toggleMenu},
            children = function()
                return {Button()}
            end
        })
    })
end
return App

