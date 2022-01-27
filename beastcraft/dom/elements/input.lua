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
    do_focus = function(self, event)
        self.super.do_focus(self, event)
    end,
    onSubmit = function(self, event)
    end,
    key = function(self, event)
        local key = keys.getName(event[2])
        if self.focused then
            if key == "backspace" then

                self.text = string.sub(self.text, 1, #self.text - 2) .. "_"
                if self.text == "__" then
                    self.text = "_"
                end
            end
            if key == "enter" then
                self:onSubmit(event)
                self:onChange("")
            else
                self:onChange(self.text)
            end
        end

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
