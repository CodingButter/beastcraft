local class = require(BEASTCRAFT_ROOT .. "core.class")
local Element = require(BEASTCRAFT_ROOT .. "dom.elements.element")
local input = class({
    constructor = function(self, props, text)
        self.super.constructor(self, "input", props, text)
    end,
    change = function(self, value)
        self.text = self.text .. value
        self:onChange()
    end,
    setFocus = function(self)
        self.super:setFocus()
        self.style.width = #self.text
        self.text = "";
    end,
    onChange = function(self)

    end,
    char = function(self, event)
        if Element.getFocusedElement() == self then
            self:change(event[2])
        end
    end
}, Element)

return function(props, text)
    return input:new(props, text)
end
