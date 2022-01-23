local utils = require("beastcraft.core.utils")
local class = require("beastcraft.core.class")
local Element = require("beastcraft.dom.elements.element")
local div = class({
    constructor = function(self, props, text)
        self.super.constructor(self, "div", props, text)
    end
}, Element)

return function(props, text)
    return div:new(props, text)
end

