local class = require("beastcraft.core.class")
local debugger = require("beastcraft.core.utils").debugger
local Element = require("beastcraft.dom.elements.element")
local input = class({
    constructor = function(self, props, text)
        text = text or ""
        local value = (#text > 1 or props.focused) and text or props.placeholder
        self.super.constructor(self, "input", props, value)
    end,
    onChange = function(self)

    end,
    onLostFocus = function(self, event)
        debugger.print("lost focus")
        if string.sub(self.text, #self.text) == "_" then
            self.text = string.sub(self.text, 1, #self.text - 1)
            self:onChange(self.text)
        end
    end,
    do_focus = function(self, event)
        if self.maxLength and #self.text <= self.maxLength and self.text ~= self.placeholder then
            self:onChange(self.text .. "_")
        end
        self.super.do_focus(self, event)
    end,
    key = function(self, event)
        if keys.getName(event[2]) == "backspace" and self.focused then
            self.text = string.sub(self.text, 1, #self.text - 2) .. "_"
            if self.text == "__" then
                self.text = "_"
            end
        end
        self:onChange(self.text)
    end,
    char = function(self, event)
        local newText = ""
        if self.focused then
            if self.maxLength and #self.text <= self.maxLength then
                self.text = string.sub(self.text, 1, #self.text - 1) .. event[2] .. "_"
            end
            self:onChange(self.text)
        end
    end
}, Element)

return function(props, text)
    return input:new(props, text)
end
