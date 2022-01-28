local rootComponent = nil
local rootElement = nil
local utils = require("beastcraft.core.utils")
local dom = require("beastcraft.dom")
local stateManager = require("beastcraft.managers.state")
local listeners = require("beastcraft.managers.listeners")
local workLoop = require("beastcraft.core.workloop")
local function addChildren(el)
    local children = el.children
    el.children = {}
    if el.children.type == "element" then
        addChildren(children)
        return el
    end
    for _, v in pairs(children) do
        if el.style.display ~= "none" then
            addChildren(v)
            el:appendChild(v)
        end
    end
    return el
end
local function render()

    stateManager.resetIndex()
    dom.resetElementStore()
    local el = addChildren(rootComponent())
    local WIDTH, HEIGHT = utils.monitor.getSize()
    rootElement.children = {}
    rootElement:appendChild(el)
    utils.window.reposition(1, 1, WIDTH, HEIGHT)
    utils.window.setVisible(false)
    dom.renderElement(rootElement)
    utils.window.setVisible(true)
    firstRender = false
end

local function renderDom(rc, re)
    rootComponent = rc
    rootElement = re
    listeners.addEventListener("render", render)
    workLoop.startWorkLoop()
end

return renderDom

