return function(require)
    local class = require("/class")
    local Style = {
        zIndex = 0,
        left = 0,
        top = 0,
        width = 0,
        height = 0,
        paddingLeft = 0,
        paddingRight = 0,
        paddingTop = 0,
        paddingBottom = 0,
        marginLeft = 0,
        marginRight = 0,
        marginTop = 0,
        marginBottom = 0,
        backgroundColor = "transparent",
        display = "none",
        
    }

    function Style:constructor(args)
        for k,v in pairs(args)do
            self[k] = v
        end
    end

    return class(Style)
end