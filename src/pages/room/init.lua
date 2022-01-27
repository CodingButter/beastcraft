local state = require"beastcraft".state
local div = require"beastcraft".ui.div
local monitor = require"beastcraft".utils.monitor
local p2pContext = require"src.hooks.usep2p".p2pContext
local roomContext = require"src.hooks.usep2p".roomContext
local UserList = require"src.pages.room.elements".UserList
local MessageInput = require"src.pages.room.elements".MessageInput
local ChatArea = require"src.pages.room.elements".ChatArea
local utils = require"beastcraft".utils
local Room = function(props)
    local WIDTH, HEIGHT = monitor.getSize()
    local p2p = state.useContext(p2pContext)
    local message, setMessage = state.useState("")
    local roomctx = state.useContext(roomContext)
    local chats, setChats = state.useState({})

    local function addChat(message, username)
        table.insert(chats, 1, {
            message = message,
            username = username
        })
        setChats(chats)
    end

    local function submitMessage(value)
        setMessage("")
        addChat(value, p2p.username)
        p2p:send("message", value)
    end

    state.useEffect(function()
        p2p:on("message", function(payload, peer)
            addChat(payload, peer.username)
        end)
    end, {})

    return div({
        id = "room-main-background",
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
        children = { --[[UserList({
            users = p2p.peers
        }),]] ChatArea({
            chats = chats
        }), MessageInput({
            message = message,
            setMessage = setMessage,
            submitMessage = submitMessage
        }), div({
            style = {
                width = 4,
                height = 2,
                left = WIDTH - 13,
                top = HEIGHT - 7,
                color = colors.white
            }
        }, roomctx.room)}
    })
end

return Room
