local utils = require(BEASTCRAFT_ROOT .. "core.utils")
local class = function(classDef, parentClass)
    -- So we dont forget that these two methods will get overwritten
    if classDef.super or classDef.new then
        error("super and new can not exist within class defenitions", 2)
    end
    -- We need access to the parent classes methods methods
    if parentClass then
        setmetatable(classDef, {
            __index = parentClass
        })
        -- Allow access to uneffected parent class methods
        classDef.super = parentClass
    end
    -- Need to create Individual Class instances
    function classDef:new(...)
        local new = {}
        setmetatable(new, {
            __index = self
        })
        -- When a class has a constructor it must be called when creating an instance
        if new.constructor then
            new:constructor(...)
        end
        return new
    end
    -- Expose the modified class definition which includes :new and .super
    return classDef
end
return class
