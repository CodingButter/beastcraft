local div = require"beastcraft".ui.div
local monitor = require"beastcraft".utils.monitor
local Router = require"beastcraft".router
local Home = require "src.pages.home"
local Lobby = require "src.pages.lobby"
local App = function()
    local WIDTH, HEIGHT = monitor.getSize()
    return div({
        id = "main-app",
        style = {
            top = 1,
            left = 1,
            width = WIDTH,
            height = HEIGHT,
            backgroundColor = colors.blue
        },
        children = Router({
            default = "Home",
            pages = {
                Home = function()
                    return Home()
                end,
                Lobby = function()
                    return Lobby()
                end
            }
        })
    })
end
return App

