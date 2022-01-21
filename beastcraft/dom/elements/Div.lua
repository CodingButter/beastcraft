local utils = require(BEASTCRAFT_ROOT .. "core.utils")
local class = require(BEASTCRAFT_ROOT .. "core.class")
local Element = require(BEASTCRAFT_ROOT .. "dom.elements.Element")
local div = class({
    constructor = function(self, props, text)
        self.super.constructor(self, "div", props, text)
    end
}, Element)

return function(props, text)
    return div:new(props, text)
end

