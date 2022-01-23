local class = require(BEASTCRAFT_ROOT .. "core.class")
local utils = require(BEASTCRAFT_ROOT.."core.utils").debugger
local Element = require(BEASTCRAFT_ROOT .. "dom.elements.element")
local input = class({
    constructor = function(self, props, text)
        self.super.constructor(self, "input", props, text)
    end,
    onChange = function(self)

    end,
    change = function(self,event)
        if event[2]==14 then self.text = string.sub(self.text,1,#self.text)
            self:onChange(self.text)
        else
            self.text
        end 
    end,
   
}, Element)

return function(props, text)
    return input:new(props, text)
end
