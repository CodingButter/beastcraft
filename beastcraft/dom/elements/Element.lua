local utils = require(BEASTCRAFT_ROOT .. "core.utils")
local class = require(BEASTCRAFT_ROOT .. "core.Class")
local Style = require(BEASTCRAFT_ROOT .. "dom.Style")
local listener = require(BEASTCRAFT_ROOT .. "managers.listeners")
local shapes = require(BEASTCRAFT_ROOT .. "core.Shape")
local Selector = require(BEASTCRAFT_ROOT .. "dom.selector")
local focusedElement = nil
local term = term
local Element = class({
    id = nil,
    children = {},
    text = false,
    type = "Element",
    constructor = function(self, tag, props, text)
        if props == nil then
            error("props not defined", 2)
        end
        for k, v in pairs(props) do
            self[k] = v
        end
        self.id = props.id or self.id
        self.style = Style:new(props.style or {})
        self.tag = tag
        self.text = text or self.text
        self:getBounds()
    end,
    appendChild = function(self, _element)

        _element.parent = self
        _element:getBounds()
        if _element.style.backgroundColor == "transparent" then
            _element.style.backgroundColor = self.style.backgroundColor
        end
        _element.style.zIndex = self.style.zIndex + _element.style.zIndex
        self.children[#self.children + 1] = _element
    end,
    prependChild = function(self, _element)
        _element.parent = self
        _element:getBounds()
        if _element.style.backgroundColor == "transparent" then
            _element.style.backgroundColor = self.style.backgroundColor
        end
        _element.style.zIndex = self.style.zIndex + _element.style.zIndex
        table.insert(self.children, 1, _element)
    end,
    loseFocus = function(self)

    end,
    setFocus = function(self, event)
        focusedElement = self:getUID()
    end,
    monitor_touch = function(self, event)
        self:mouse_click(event)
    end,
    mouse_up = function(self, event)
        self:onRelease(event)
    end,
    onRelease = function(self, event)
    end,
    onClick = function(self, event)
    end,
    mouse_click = function(self, event)
        if self.style.display == "none" then
            return false
        end
        local left, top, width, height = self:getBounds()
        local x = event[3]
        local y = event[4]
        if x >= left and x < left + width and y >= top and y < top + height then
            self:setFocus(event)
            if self.onClick then
                self:onClick(event)
            end
            return true
        end
        self:loseFocus()
        return false
    end,
    getBounds = function(self)
        local offsetLeft = 0
        local offsetTop = 0
        if self.parent then
            offsetLeft = self.parent.offsetLeft
            offsetTop = self.parent.offsetTop
        end
        local style = self.style
        offsetLeft = offsetLeft + style.left + style.marginLeft
        offsetTop = offsetTop + style.top + style.marginTop
        local width = style.width + style.paddingLeft + style.paddingRight
        local height = style.height + style.paddingTop + style.paddingBottom
        self.offsetLeft = offsetLeft
        self.offsetTop = offsetTop
        return offsetLeft, offsetTop, width, height
    end,
    render = function(self)
        local style = self.style
        local color = style.color
        local backgroundColor = style.backgroundColor
        local left, top, width, height = self:getBounds()
        if style.display ~= "none" then
            if style.backgroundColor ~= "transparent" then
                if style.borderColor then
                    shapes.drawButton(left, top, width, height, style.borderColor, style.highlightColor,
                        style.backgroundColor, self.parent.style.backgroundColor)
                else
                    shapes.drawFilledBox(left, top, width, height, self.style.backgroundColor)
                end
            else
                if self.parent then
                    self.style.backgroundColor = self.parent.style.backgroundColor
                end
            end
            if self.text then
                term.setBackgroundColor(backgroundColor)
                term.setTextColor(color)
                term.setCursorPos(left + style.paddingLeft + 3, top + style.paddingTop + 1)
                term.write(self.text)
            end
            table.sort(self.children, function(a, b)
                return a.style.zIndex < b.style.zIndex
            end)
            for k, v in ipairs(self.children) do
                v:render()
            end
        end
    end,
    event = function(self, event)
        if event[1] ~= "monitor_touch" or event[1] ~= "mouse_click" then
            for i = #self.children, 1, -1 do
                local v = self.children[i]
                v:event(event)
            end
        end
        local childClicked = false
        for i = #self.children, 1, -1 do
            local v = self.children[i]
            if v:event(event) then
                if childClicked == false then
                    childClicked = true
                end
            end
        end
        if childClicked then
            return true
        end
        if self[event[1]] then
            return self[event[1]](self, event)
        end
        return false
    end,
    getUID = function(self)
        if self.id == nil then
            self.id = math.random(1, 1000)
        end
        return self.id
    end,
    getElementById = function(self, idName)
        return Selector.getElementById(self, idName)
    end,
    getElementsByClassName = function(self, className)
        return Selector.getElementsByClassName(self, className)
    end,
    getElementsByTagName = function(self, tagName)
        return Selector.getElementById(self, tagName)
    end,
    getElementsByAttribute = function(self, attribute)
        return Selector.getElementsByAttribute(self, attribute)
    end,
    addEventListener = function(self, event, func)
        return listener.addEventListener(event, func)
    end,
    removeEventListener = function(self, eventName, listenerId)
        listener.removeEventListener(eventName, listenerId)
    end
})

Element.getFocusedElement = function()
    return focusedElement
end
return Element