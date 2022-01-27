local utils = require("beastcraft.core.utils")
local class = require("beastcraft.core.class")
local Style = require("beastcraft.dom.style")
local listener = require("beastcraft.managers.listeners")
local shapes = require("beastcraft.core.shape")
local Selector = require("beastcraft.dom.selector")
local term = term
local Element = class({
    id = nil,
    children = {},
    text = false,
    type = "element",
    keypressed = false,
    appended = false,
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
        self.text = text or self.text or ""
        local iterator = 1
        for match in self.text:gmatch("[^\r\n]+") do
            iterator = iterator + 1
        end
        self.style.height = math.max(self.style.height, iterator + 1)
        self.focused = props.focused or false
        self:getBounds()
        if focused == self.id then
            self.focused = true
        end
    end,
    appendChild = function(self, _element)
        _element.parent = self

        _element.appended = true
        _element:getBounds()
        if _element.style.backgroundColor == "transparent" then
            _element.style.backgroundColor = self.style.backgroundColor
        end
        _element.style.zIndex = self.style.zIndex + _element.style.zIndex
        if self.style.display ~= "block" then
            _element.style.display = "none"
        end
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
    onLostFocus = function(self)
    end,
    onFocus = function(self, event)
    end,
    do_monitor_touch = function(self, event)
        self:do_mouse_click(event)
        self.clickedEvent = self:addEventListener("timer", function()
            self:onRelease(event)
            self:removeEventListener("timer", self.clickedEvent)
        end)
    end,
    monitor_touch = function(self, event)
        return self:mouse_click(event)

    end,
    key = function(self, event)
    end,
    key_up = function(self, event)
        self.keypressed = false
    end,
    mouse_up = function(self, event)
        self:onRelease(event)
    end,
    onRelease = function(self, event)
    end,
    onClick = function(self, event)
    end,
    do_focus = function(self, event)
        self:onFocus(event)
    end,
    do_mouse_click = function(self, event)
        self.focused = true
        self:do_focus(event)
        self:onClick(event, self)
    end,
    mouse_click = function(self, event)
        if self.style.display ~= "none" and (self.parent and self.parent.style.display ~= "none") then
            local left, top, width, height = self:getBounds()
            local x = event[3]
            local y = event[4]
            if x >= left and x < left + width and y >= top and y < top + height and self.style.display ~= "none" then
                return true
            end
        end
        return false
    end,
    getBounds = function(self)
        local offsetLeft = 0
        local offsetTop = 0
        if self.parent and not self.parent.style.window then
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
        if self.style.display ~= "none" then
            local style = self.style
            local color = style.color
            local backgroundColor = style.backgroundColor
            local left, top, width, height = self:getBounds()
            local oldTerm = nil
            if style.window then
                style.window.reposition(left, top, width, height)
                left = 1
                top = 1
                oldTerm = term.redirect(style.window)
            end
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
                local i = 1
                term.setTextColor(color)
                for s in self.text:gmatch("[^\r\n]+") do
                    term.setCursorPos(left + style.paddingLeft + 3, top + style.paddingTop + i)
                    term.write(s)
                    i = i + 1
                end
            end

            table.sort(self.children, function(a, b)
                return a.style.zIndex < b.style.zIndex
            end)
            for k, v in ipairs(self.children) do
                v:render()
            end
            if style.window then
                term.redirect(oldTerm)
            end
        end
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
return Element
