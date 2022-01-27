local div = require"beastcraft".ui.div
local monitor = require"beastcraft".utils.monitor
local useP2P = require"src.hooks.usep2p".useP2P
local Router = require"beastcraft".router
local Home = require "src.pages.home"
local Room = require "src.pages.room"
local Lobby = require "src.pages.lobby"
local NewRoom = require "src.pages.newroom"
local App = function(props)
    local WIDTH, HEIGHT = monitor.getSize()
    return useP2P({
        p2p = props.p2p,
        children = function()
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
                        NewRoom = function()
                            return NewRoom()
                        end,
                        Lobby = function()
                            return Lobby()
                        end,
                        Home = function()
                            return Home()
                        end,
                        Room = function()
                            return Room()
                        end
                    }
                })
            })
        end
    })
end
return App

