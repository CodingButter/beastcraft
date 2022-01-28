local state = require"beastcraft".state
local routerContext = require"beastcraft".routerContext
local div = require"beastcraft".ui.div
local map = require"beastcraft".utils.table.map
local Button = require "src.components.button"
local debugger = require"beastcraft".utils.debugger
local p2pContext = require"src.hooks.usep2p".p2pContext
local lobby = require"src.hooks.usep2p".lobby
local roomContext = require"src.hooks.usep2p".roomContext
local RoomList = function(props)
    local roomctx = state.useContext(roomContext)
    local page, setPage = table.unpack(state.useContext(routerContext))
    local p2p = state.useContext(p2pContext)
    return div({
        id = 'roomlist-background',
        style = props.style,
        children = (function()
            return map(props.rooms, function(room, i)
                local startIndex = props.page * props.itemsPerPage - props.itemsPerPage
                local display = false
                if i >= startIndex and i <= startIndex + props.itemsPerPage then
                    display = true
                end

                return Button({
                    id = room.room .. "-btn",
                    style = {
                        display = display and "block" or "none",
                        width = props.style.width,
                        height = 3,
                        top = i * 4 - 3
                    },
                    onClick = function(self, event)
                        roomctx.setRoom(room.room)
                        setPage("Room")
                        p2p:connect(lobby, room.room)
                    end,
                    label = room.room .. "(" .. room.users .. ")"
                })
            end)
        end)()
    })
end
local NewRoom = function(props)
    local page, setPage = table.unpack(state.useContext(routerContext))
    return Button({
        id = 'new-room-btn',
        style = props.style,
        label = "New Room",
        onClick = function(self, event)
            setPage("NewRoom")
        end
    })
end
return {
    NewRoom = NewRoom,
    RoomList = RoomList
}
