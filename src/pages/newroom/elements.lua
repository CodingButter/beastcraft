local state = require"beastcraft".state
local routerContext = require"beastcraft".routerContext
local div = require"beastcraft".ui.div
local map = require"beastcraft".utils.table.map
local Button = require "src.components.button"
local debugger = require"beastcraft".utils.debugger
local roomContext = require"src.hooks.usep2p".roomContext
local ChatList = function(props)
    local roomctx = state.useContext(roomContext)
    local page, setPage = table.unpack(state.useContext(routerContext))
    return div({
        id = "chatlist-background",
        style = props.style,
        children = (function()
            return map(props.rooms, function(room, i)
                local startIndex = props.page * props.itemsPerPage - props.itemsPerPage
                local display = false
                if i > startIndex and i < startIndex + props.itemsPerPage then
                    display = true
                end

                return div({
                    id = room.room .. "-btn",
                    style = {
                        display = display and "block" or "none",
                        width = props.style.width,
                        height = 3,
                        top = i * 3 - 3
                    },
                    onClick = function(self, event)
                        roomctx.setRoom(room.room)
                        setPage("Room")
                    end,
                    label = room.room .. "(" .. room.users .. ")"
                })
            end)
        end)()
    })
end
local UserList = function(props)
    local page, setPage = table.unpack(state.useContext(routerContext))
    local height = 1
    return div({
        id = "new-room-userlist-background",
        style = props.style,
        children = map(props.users, function(user, i)
            return div({
                id = user.username .. "-div-" .. i,
                style = {
                    width = props.style.width,
                    height = height,
                    top = i * height - height,
                    backgroundColor = colors.white
                }
            }, user.username)
        end)

    })
end

return {
    ChatList = ChatList,
    UserList = UserList
}
