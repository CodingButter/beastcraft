local state = require"beastcraft".state
local routerContext = require"beastcraft".routerContext
local input = require"beastcraft".ui.input
local map = require"beastcraft".utils.table.map
local Button = require "src.components.button"
local debugger = require"beastcraft".utils.debugger
local roomContext = require"src.hooks.usep2p".roomContext
local p2pContext = require"src.hooks.usep2p".p2pContext
local lobby = require"src.hooks.usep2p".lobby
local monitor = require"beastcraft".utils.monitor
local Username = function(props) -- Yeah we got props boys
    local WIDTH, HEIGHT = monitor.getSize()
    return input({
        id = "username-input",
        placeholder = "*Username",
        maxLength = 24,
        style = {
            left = WIDTH / 3 - 12,
            top = 2,
            width = 24,
            height = 3,
            focusedBackgroundColor = colors.lightGray,
            backgroundColor = pressed and colors.lightGray or colors.gray,
            color = colors.white,
            highlightColor = pressed and colors.gray or colors.lightGray,
            borderColor = colors.yellow
        },
        onChange = function(self, value)
            props.setUsername(value)
        end,
        onClick = function(self, event)
        end,
        onRelease = function(self, event)
        end
    }, props.username)
end
local RoomName = function(props) -- Yeah we got props boys
    local WIDTH, HEIGHT = monitor.getSize()
    return input({
        id = "room-name-input",
        placeholder = "*Room Name",
        maxLength = 24,
        style = {
            left = WIDTH / 3 - 12,
            top = 7,
            width = 24,
            height = 3,
            focusedBackgroundColor = colors.lightGray,
            backgroundColor = pressed and colors.lightGray or colors.gray,
            color = colors.white,
            highlightColor = pressed and colors.gray or colors.lightGray,
            borderColor = colors.yellow
        },
        onChange = function(self, value)
            props.setRoomName(value)
        end,
        onClick = function(self, event)
        end,
        onRelease = function(self, event)
        end
    }, props.roomName)
end

local Password = function(props) -- Yeah we got props boys
    local WIDTH, HEIGHT = monitor.getSize()
    return input({
        id = "password-input",
        placeholder = "Password",
        maxLength = 20,
        style = {
            left = WIDTH / 3 - 12,
            top = 12,
            width = 24,
            height = 3,
            focusedBackgroundColor = colors.lightGray,
            backgroundColor = pressed and colors.lightGray or colors.gray,
            color = colors.white,
            highlightColor = pressed and colors.gray or colors.lightGray,
            borderColor = colors.yellow
        },
        onChange = function(self, value)
            props.setPassword(value)
        end,
        onClick = function(self, event)
        end,
        onRelease = function(self, event)
        end
    }, props.password)
end
local CreateRoomButton = function(props)
    local WIDTH, HEIGHT = monitor.getSize()
    local page, setPage = table.unpack(state.useContext(routerContext))
    local p2p = state.useContext(p2pContext)
    local roomctx = state.useContext(roomContext)
    return Button({
        id = "createRoom-btn",
        label = "Create Room",
        style = {
            left = WIDTH / 3 - 12,
            width = 24,
            top = 17,
            height = 3
        },
        onClick = function(self, event)
            roomctx.setRoom(props.roomName)
            setPage("Room")
            p2p.username = props.username
            p2p:connect(lobby, props.roomName)
        end
    })
end
return {
    Username = Username,
    RoomName = RoomName,
    Password = Password,
    CreateRoomButton = CreateRoomButton
}
