local Elements = require(BEASTCRAFT_ROOT .. "dom.elements")

local elementStore = {}
local root = false

local function createElement(tag, props, text)
    local newElement = Elements[tag](props, text)
    elementStore[#elementStore + 1] = newElement
    return newElement
end

local body = createElement("body", {})

local function triggerEvent(event)
    body:event(event)
end

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
