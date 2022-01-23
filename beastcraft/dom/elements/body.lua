local class = require("core.class")
local Element = require("dom.elements.element")
local body = class({
    constructor = function(self, props, text)
        props.style = {
            width = WIDTH,
            height = HEIGHT,
            backgroundColor = colors.white,
            color = colors.black
        }
        self.super.constructor(self, "body", props, text)
    end
}, Element)

return function(props, text)
    return body:new(props, text)
end

