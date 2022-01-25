local div = require"beastcraft".ui.div
local button = require"beastcraft".ui.button
local P2PContext = require "src.context.p2pcontext"
local map = require"beastcraft".utils.table.map
local state = require"beastcraft".state
local debugger = require"beastcraft".utils.debugger
local workLoop = require"beastcraft".workLoop.startWorkLoop
local Menu = function(props)
    local lobby = "alobby"
    local room = "myRoom"
    local p2p = state.useContext(P2PContext)
    local rooms, setRooms = state.useState({})

    local function connect()
        p2p:connect({
            eventLoop = workLoop,
            lobby = lobby,
            room = room
        })
    end
    state.useEffect(function()
        if p2p.getRooms then
            debugger.printTable(p2p.getRooms(lobby))
            setRooms(p2p.getRooms(lobby))
        end
    end, {lobby, p2p})

    return div({
        id = "toggle-menu",
        style = {
            width = 18,
            height = 10,
            left = 24,
            top = 3,
            display = props.showMenu and "block" or "none",
            backgroundColor = colors.gray,
            color = colors.white,
            highlightColor = colors.lightGray,
            borderColor = colors.yellow
        },
        children = map(rooms, function(room, i)
            return button({
                style = {
                    left = 2,
                    top = i * 3,
                    height = 2,
                    width = 14,
                    backgroundColor = colors.gray,
                    color = colors.white,
                    highlightColor = colors.lightGray,
                    borderColor = colors.yellow
                },
                onClick = function(self, event)
                    connect(room.room)
                end
            }, room.room .. "(" .. room.users .. ")")
        end)
    }, "Rooms")
end
return Menu
