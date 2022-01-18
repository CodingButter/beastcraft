return function(require)
    function render(elements,canvas)
        local term = canvas or term
        table.sort(elements,function(a,b)
            return a.renderDepth<b.renderDepth
        end)

        for _,elm in paris(elements)
            local style = elm.style
            local color = style.color
            local backgroundColor = style.backgroundColor
            local left, top, width, height = elm:getBounds()
            if style.display ~= "none" then
                if style.backgroundColor ~= "transparent" then
                    paintutils.drawFilledBox(left, top, width, height, elm.style.backgroundColor)
                else
                    if elm.parent then
                        elm.style.backgroundColor = elm.parent.style.backgroundColor
                    end
                end
                if elm.content then
                    term.setBackgroundColor(elm.style.backgroundColor)
                    term.setTextColor(color)
                    term.setCursorPos(left + style.paddingLeft + 1, top + style.paddingTop)
                    term.write(elm.content)
                    term.setCursorPos(10, 10)
                end
            end
        end
    end
end