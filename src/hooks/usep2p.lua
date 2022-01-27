local state = require"beastcraft".state
local P2P = require "p2p"
local p2pContext = state.createContext({})
local roomContext = state.createContext({})
local lobby = "mcChat"
local useP2P = function(props)
    local room, setRoom = state.useState(nil)
    local roomList, setRoomList = state.useState({})
    return p2pContext.Provider({
        value = props.p2p,
        children = function()
            return roomContext.Provider({
                value = {
                    room = room,
                    setRoom = setRoom,
                    roomList = roomList,
                    setRoomList = setRoomList
                },
                children = props.children
            })
        end
    })
end

return {
    p2pContext = p2pContext,
    roomContext = roomContext,
    lobby = lobby,
    useP2P = useP2P
}
