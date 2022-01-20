local rootComponent = nil
local rootElement
local utils = require(BEASTCRAFT_ROOT .. "core.utils")
local stateManager = require(BEASTCRAFT_ROOT .. "managers.state")
local listeners = require(BEASTCRAFT_ROOT .. "managers.listeners")
local workLoop = require(BEASTCRAFT_ROOT .. "core.Workloop")
local function addChildren(el)
    utils.debugger.print(el)
    local children = el.children
    el.children = {}
    if el.children.type == "Element" then
        addChildren(children)
        return el
    end

    for _, v in pairs(children) do
        addChildren(v)
        el:appendChild(v)
    end
    return el
end
local function render()
    utils.debugger.print("rendering in loop")
    stateManager.resetIndex()
    local el = addChildren(rootComponent())
    rootElement.children = {}
    rootElement:appendChild(el)

    local WIDTH, HEIGHT = term.getSize()
    utils.window.reposition(1, 1, WIDTH, HEIGHT)
    utils.window.setVisible(false)
    utils.window.clear()
    rootElement:render()
    utils.window.setVisible(true)
end

local function renderDom(rc, re)
    rootComponent = rc
    rootElement = re
    listeners.addEventListener("render", render)
    workLoop.startWorkLoop()
end

return renderDom

