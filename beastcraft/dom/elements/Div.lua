return function(utils)
    local utils = require(BEASTCRAFT_ROOT .. "core.Utils")
    local class = require(BEASTCRAFT_ROOT .. "core.Class")
    local Element = require(BEASTCRAFT_ROOT .. "dom.elements.Element")
    local div = class({
        constructor = function(self, props, text)
            self.super.constructor(self, "div", props, text)
        end
    }, Element)

    return function(props, text)

        if props == nil then
            error("no props passed into div", 2)
        end
        return div:new(props, text)
    end
end

