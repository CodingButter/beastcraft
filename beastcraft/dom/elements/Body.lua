local class = require(BEASTCRAFT_ROOT .. "core.Class")
local Element = require(BEASTCRAFT_ROOT .. "dom.elements.Element")
local body = class({
    constructor = function(self, props, text)
        self.super.constructor(self, "body", props, text)
    end
}, Element)

return function(props, text)
    return body:new(props, text)
end

