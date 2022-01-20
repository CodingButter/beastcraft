local function getElementById(element, idName)
    for _, v in pairs(element.children) do
        if v.id == idName then
            return v
        end
    end
end

local function getElementsByClassName(element, className)
    local elements = {}
    for _, v in pairs(element.children) do
        if v.class then
            if type(v.class) == "string" then
                if v.class == className then
                    elements[#elements + 1] = v
                end
            else
                for _, cn in pairs(v.class) do
                    if cn == className then
                        elements[#elements + 1] = v
                    end
                end
            end
        end
        for _, recursiveResult in pairs(getElementsByClassName(v, className)) do
            elements[#elements + 1] = recursiveResult
        end
    end
    return elements
end

local function getElementsByTagName(element, tagName)
    local elements = {}
    for _, v in pairs(element.children) do
        if v.tag == tagName then
            elements[#elements + 1] = v
        end
        for _, recursiveResult in pairs(getElementsByTagName(v, tagName)) do
            elements[#elements + 1] = recursiveResult
        end
    end
    return elements
end

---  TODO: Get OR_MODE working correctly

local function getElementsByAttribute(element, attribute, mode)
    mode = mode or "AND_MODE"
    local elements = {}
    for _, elm in pairs(element.children) do
        if type(attribute) == "string" then
            if elm[attribute] then
                elements[#elements + 1] = elm
            end
        else
            local addElement = mode == "AND_MODE"
            for k, attr in pairs(attribute) do
                if mode == "AND_MODE" then
                    if type(k) == "number" and not elm[attr] then
                        addElement = false
                    elseif elm[k] ~= attr then
                        addElement = false
                    end
                else
                    if type(k) == "number" and elm[attr] then
                        addElement = true
                    elseif elm[k] == attr then
                        addElement = true
                    end
                end
            end
            if addElement then
                elements[#elements + 1] = elm
            end
        end
        for _, recursiveResult in pairs(getElementsByAttribute(elm, attribute)) do
            elements[#elements + 1] = recursiveResult
        end
    end
    return elements
end

return {
    getElementById = getElementById,
    getElementsByClassName = getElementsByClassName,
    getElementsByAttribute = getElementsByAttribute
}

