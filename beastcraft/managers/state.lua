local utils = require "beastcraft.core.utils"
local hookStorage = {}
local hookIndex = 1
local contextStorage = {}

local function useState(initState)
    local state = hookStorage[hookIndex] or initState
    hookStorage[hookIndex] = state
    local frozenIndex = hookIndex
    local function setState(newVal)
        if type(newVal) == "function" then
            newVal = newVal(state)
        end
        hookStorage[frozenIndex] = newVal
    end
    hookIndex = hookIndex + 1
    return state, setState
end

local function useRef(val)
    local state = useState({
        current = val
    })
    return state
end

local function useReducer(_reducer, initVal)
    local state, setState = useState(initVal)
    local function dispatch(action)
        setState(_reducer(state, action))
    end
    return state, dispatch
end

local function useEffect(cb, depArray)
    local oldDeps = hookStorage[hookIndex]
    local hasChanged = true

    if oldDeps then
        hasChanged = utils.table.is(depArray, oldDeps) == false
    end
    if hasChanged and depArray ~= nil then
        cb()
    end
    hookStorage[hookIndex] = depArray
    hookIndex = hookIndex + 1
end

local function resetIndex()
    hookIndex = 1
end

local createContext = function(val)
    local frozenIndex = #contextStorage + 1
    contextStorage[frozenIndex] = val
    return {
        index = frozenIndex,
        Provider = function(props)
            contextStorage[frozenIndex] = props.value
            return props.children()
        end
    }
end
local useContext = function(ctx)
    return contextStorage[ctx.index]
end

return {
    useState = useState,
    useRef = useRef,
    useReducer = useReducer,
    useEffect = useEffect,
    createContext = createContext,
    useContext = useContext,
    resetIndex = resetIndex
}
