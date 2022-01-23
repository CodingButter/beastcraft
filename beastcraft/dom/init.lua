local Elements = require("dom.elements")
local listener = require("managers.listeners")
local utils = require("core.utils")
local elementStore = {}
local root = false
local focused = {}

local function createElement(tag, props, text)
    local elmIndex = #elementStore + 1
    props.id = props.id or elmIndex
    if focused == props.id then
        props.focused = true
    end
    local newElement = Elements[tag](props, text)
    elementStore[elmIndex] = newElement
    return newElement
end

local body = createElement("body", {
    style = {
        left = 1,
        top = 1
    },
    children = {}
})
elementStore = {}
local function triggerEvent(event)
    local triggered = false
    for i = 1, #elementStore do
        local elm = elementStore[i]
        if elm[event[1]] then
            local status = elm[event[1]](elm, event)
            if status == true and triggered == false and elm["do_" .. event[1]] then
                triggered = true
                focused = elm.id
                elm["do_" .. event[1]](elm, event)
            end
        end
    end
end

listener.addEventListener("monitor_touch", triggerEvent)
listener.addEventListener("mouse_click", triggerEvent)
listener.addEventListener("mouse_up", triggerEvent)
listener.addEventListener("timer", triggerEvent)
listener.addEventListener("key", triggerEvent)
listener.addEventListener("key_up", triggerEvent)
listener.addEventListener("char", triggerEvent)

local function getElementById(idName)
    return body:getElementById(idName)
end
local function getElementsByClassName(className)
    return body:getElementsByClassName(className)
end
local function getElementsByTagName(tagName)
    return body:getElementsByTagName(tagName)
end
local function getElementsByAttribute(attribute)
    return body:getElementsByAttribute(attribute)
end
local function render()
    body:render()
end
local function renderElement(element)
    element:render()
end
local function resetElementStore()
    elementStore = {}
end
local button = function(props, text)
    return createElement("button", props, text)
end
local input = function(props, text)
    return createElement("input", props, text)
end
local div = function(props, text)
    return createElement("div", props, text)
end
return {
    resetElementStore = resetElementStore,
    renderElement = renderElement,
    body = body,
    createElement = createElement,
    getElementById = getElementById,
    getElementsByClassName = getElementsByClassName,
    getElementsByTagName = getElementsByTagName,
    getElementsByAttribute = getElementsByAttribute,
    button = button,
    div = div,
    input = input
}
