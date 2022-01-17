local class = function(classDef, parentClass)
    if classDef.super then
        error("super is a protected attribute", 2)
    end
    if classDef.new then
        error("new is a protected method", 2)
    end
    if parentClass then
        setmetatable(classDef, {
            __index = parentClass
        })
        classDef.super = parentClass
    end
    function classDef:new(...)
        local new = {}
        setmetatable(new, {
            __index = self
        })
        if new.constructor then
            new:constructor(...)
        end
        return new
    end
    return classDef
end
return class
