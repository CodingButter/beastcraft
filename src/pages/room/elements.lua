local state = require"beastcraft".state
local routerContext = require"beastcraft".routerContext
local div = require"beastcraft".ui.div
local input = require"beastcraft".ui.input
local map = require"beastcraft".utils.table.map
local Button = require "src.components.button"
local debugger = require"beastcraft".utils.debugger
local monitor = require"beastcraft".utils.monitor
local roomContext = require"src.hooks.usep2p".roomContext
local chatsWindow = window.create(term.current(), 1, 1, 1, 1)

local ChatArea = function(props)
    local WIDTH, HEIGHT = monitor.getSize()
    local roomctx = state.useContext(roomContext)
    return div({
        id = "chat-list-background",
        style = {
            top = 1,
            left = 3,
            width = WIDTH - 7,
            backgroundColor = colors.lightGray,
            height = 13,
            window = chatsWindow
        },
        children = map(props.chats, function(chat, i)
            return div({
                id = chat.username .. "-" .. i,
                style = {
                    display = i <= 4 and "block" or "none",
                    width = WIDTH - 7,
                    height = 3,
                    top = 13 - i * 3,
                    left = 1,
                    backgroundColor = colors.white
                }
            }, chat.username .. ":\n" .. chat.message)
        end)
    })
end
local UserList = function(props)
    local WIDTH, HEIGHT = monitor.getSize()
    local page, setPage = table.unpack(state.useContext(routerContext))
    local height = 2
    return div({
        id = "room-user-list",
        style = {
            width = 12,
            height = HEIGHT - 5,
            top = 1,
            left = WIDTH - 21

        },
        children = map(props.users, function(user, i)
            return div({
                id = user.username .. "-btn",
                style = {
                    width = 15,
                    height = height,
                    top = i * height - height,
                    backgroundColor = colors.white
                }
            }, user.username)
        end)
    })
end

local MessageInput = function(props) -- Yeah we got props boys
    local WIDTH, HEIGHT = monitor.getSize()
    return input({
        id = "message-input",
        placeholder = "Message",
        maxLength = WIDTH - 20,
        style = {
            left = 2,
            top = HEIGHT - 6,
            width = WIDTH - 15,
            height = 3,
            focusedBackgroundColor = colors.lightGray,
            backgroundColor = pressed and colors.lightGray or colors.gray,
            color = colors.white,
            highlightColor = pressed and colors.gray or colors.lightGray,
            borderColor = colors.yellow
        },
        onSubmit = function(self, event)
            props.submitMessage(string.sub(props.message, 1, #props.message - 1))
        end,
        onChange = function(self, value)
            props.setMessage(value)
        end,
        onClick = function(self, event)
        end,
        onRelease = function(self, event)
        end
    }, props.message)
end

return {
    ChatArea = ChatArea,
    UserList = UserList,
    MessageInput = MessageInput
}
