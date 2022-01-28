local state = require"beastcraft".state
local div = require"beastcraft".ui.div
local monitor = require"beastcraft".utils.monitor
local p2pContext = require"src.hooks.usep2p".p2pContext
local roomContext = require"src.hooks.usep2p".roomContext
local Password = require"src.pages.newroom.elements".Password
local RoomName = require"src.pages.newroom.elements".RoomName
local Username = require"src.pages.newroom.elements".Username
local CreateRoomButton = require"src.pages.newroom.elements".CreateRoomButton
local utils = require"beastcraft".utils
local NewRoom = function(props)
    local WIDTH, HEIGHT = monitor.getSize()
    local p2p = state.useContext(p2pContext)
    local roomctx = state.useContext(roomContext)
    local username, setUsername = state.useState("")
    local roomName, setRoomName = state.useState("")
    local password, setPassword = state.useState("")
    return div({
        id = "new-room-background",
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
        children = {Username({
            setUsername = setUsername,
            username = username
        }), RoomName({
            setRoomName = setRoomName,
            roomName = roomName
        }), Password({
            setPassword = setPassword,
            password = password
        }), CreateRoomButton({
            roomName = roomName,
            username = username
        })}
    })
end

return NewRoom
