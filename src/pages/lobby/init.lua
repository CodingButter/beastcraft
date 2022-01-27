local state = require"beastcraft".state
local div = require"beastcraft".ui.div
local monitor = require"beastcraft".utils.monitor
local p2pContext = require"src.hooks.usep2p".p2pContext
local roomContext = require"src.hooks.usep2p".roomContext
local debugger = require"beastcraft".utils.debugger
local lobby = require"src.hooks.usep2p".lobby
local RoomList = require"src.pages.lobby.elements".RoomList
local NewRoom = require"src.pages.lobby.elements".NewRoom

local Lobby = function(props)
    local WIDTH, HEIGHT = monitor.getSize()
    local p2p = state.useContext(p2pContext)
    local page, setPage = state.useState(1)
    local roomctx = state.useContext(roomContext)
    local itemsPerPage = 3
    return div({
        id = "lobby-main-background",
        style = {
            left = 1,
            width = WIDTH - 2,
            height = HEIGHT - 2,
            top = 1,
            color = colors.white,
            backgroundColor = colors.gray,
            highlightColor = colors.lightGray,
            borderColor = colors.yellow
        },
        children = {RoomList({
            style = {
                width = 18,
                left = 13,
                height = itemsPerPage * 3,
                top = 2,
                backgroundColor = colors.lightGray
            },
            page = page,
            itemsPerPage = itemsPerPage,
            rooms = roomctx.roomList
        }), NewRoom({
            style = {
                width = 13,
                left = WIDTH - 18,
                height = 3,
                top = 2
            }
        })}
    }, "Lobby")
end

return Lobby
