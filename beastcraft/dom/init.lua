local Elements = require(BEASTCRAFT_ROOT .. "dom.elements")
local listener = require(BEASTCRAFT_ROOT .. "managers.listeners")
local utils = require(BEASTCRAFT_ROOT .. "core.utils")
local elementStore = {}
local root = false

local function createElement(tag, props, text)
    local newElement = Elements[tag](props, text)
    elementStore[#elementStore + 1] = newElement
    return newElement
end

local body = createElement("body", {
    style = {
        left = 1,
        top = 1
    },
    children = {}
})

local function triggerEvent(event)
    body:event(event)
end
listener.addEventListener("monitor_touch", triggerEvent)
listener.addEventListener("mouse_click", triggerEvent)
listener.addEventListener("mouse_up", triggerEvent)
listener.addEventListener("timer", triggerEvent)
listener.addEventListener("key_down",triggerEvent)
listener.addEventListener("key_up",triggerEvent)
listener.addEventListener("char",triggerEvent)
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

return {
    body = body,
    createElement = createElement,
    getElementById = getElementById,
    getElementsByClassName = getElementsByClassName,
    getElementsByTagName = getElementsByTagName,
    getElementsByAttribute = getElementsByAttribute
}
