local class = require(BEASTCRAFT_ROOT .. "core.Class")
local Element = require(BEASTCRAFT_ROOT .. "dom.elements.Element")
local Style = require(BEASTCRAFT_ROOT .. "dom.Style")
local shape = require(BEASTCRAFT_ROOT .. "core.Shape")

local button = class({

    constructor = function(self, props, text)
        self.super.constructor(self, "button", props, text)
    end,
    render = function(self)
        if Element.getFocusedElement() == self:getUID() and self.style.focusedBackgroundColor then
            local oldBgColor = self.style.backgroundColor
            self.style.backgroundColor = self.style.focusedBackgroundColor
            self.super.render(self)
            self.style.backgroundColor = oldBgColor
        else
            self.super.render(self)
        end
    end
}, Element)

return function(props, text)
    return button:new(props, text)
end

