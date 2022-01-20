local hookStorage = {}
local hookIndex = 1
local contextStorage = {}

local function useState(initState)
    local state = hookStorage[hookIndex] or initState
    hookStorage[hookIndex] = state
    local frozenIndex = hookIndex
    local function setState(newVal)
        if type(newVal) == "function" then
            newVal = newVal(hookStorage[frozenIndex])
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
    local hasChanged = false

    if oldDeps then
        hasChanged = utils.table.is(depArray, oldDeps) == false
    end
    if hasChanged then
        cb()
    end
    hookStorage[hookIndex] = depArray
end

local function resetIndex()
    hookIndex = 1
end

local function createContext(val)
    local index = #contextStorage + 1
    contextStorage[index] = val
    return {
        index = index,
        Provider = function(self, props)
            contextStorage[index] = props.value
            return props.children
        end
    }
end

local function useContext(context)
    return contextStorage[context.index]
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
