local class = require(BEASTCRAFT_ROOT .. "core.class")
local Element = require(BEASTCRAFT_ROOT .. "dom.elements.element")
local Style = require(BEASTCRAFT_ROOT .. "dom.style")
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

