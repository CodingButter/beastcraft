local class = require(BEASTCRAFT_ROOT .. "core.Class")
local Element = require(BEASTCRAFT_ROOT .. "dom.elements.Element")
local Style = require(BEASTCRAFT_ROOT .. "dom.Style")
local ul = class({
    style = Style:new({
        backgroundColor = colors.gray,
        focusedBackgroundColor = colors.lightGray
    }),
    constructor = function(self, props, text)
        self.super.constructor(self, "u", props, text)
    end
}, Element)

return function(props, text)
    return ul:new(props, text)
end

