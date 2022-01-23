--- Draw various shapes on the screen.
-- @module[kind=gui] Shape
local shape = {}
local expect = require("beastcraft.cc.expect").expect

--- Draw a filled rectangle.
-- @tparam number x X coordinate of rectangle.
-- @tparam number y Y coordinate of rectangle.
-- @tparam number w Width of rectangle.
-- @tparam number h Height of rectangle.
-- @tparam number|string col Colour of rectangle, accepts blit or `colours.` colour.
function shape.drawFilledBox(x, y, w, h, col, ch, chcol)
    expect(1, x, "number")
    expect(2, y, "number")
    expect(3, w, "number")
    expect(4, h, "number")
    expect(5, col, "number", "string")
    if type(col) == "number" then
        col = colours.toBlit(col)
    end
    chcol = chcol or col
    if type(chcol) == "number" then
        chcol = colours.toBlit(chcol)
    end
    for i = 1, h do
        term.setCursorPos(x, y + i - 1)
        term.blit((ch or " "):rep(w), chcol:rep(w), col:rep(w))
    end
end

--- Draw a hollow rectangle.
-- @tparam number x X coordinate of rectangle.
-- @tparam number y Y coordinate of rectangle.
-- @tparam number w Width of rectangle.
-- @tparam number h Height of rectangle.
-- @tparam number|string col Colour of rectangle, accepts blit or `colours.` colour.
function shape.rectangle(x, y, w, h, col, ch)
    expect(1, x, "number")
    expect(2, y, "number")
    expect(3, w, "number")
    expect(4, h, "number")
    expect(5, col, "number", "string")
    if type(col) == "number" then
        col = colours.toBlit(col)
    end
    for i = 1, h do
        if i == y or i == h then
            term.setCursorPos(x, y + i - 1)
            term.blit((ch or " "):rep(w), col:rep(w), col:rep(w))
        else
            term.setCursorPos(x, y + i - 1)
            term.blit(ch or " ", col, col)
            term.setCursorPos(x + w - 1, y + i - 1)
            term.blit(ch or " ", col, col)
        end
    end
end

--- Draw a hollow triangle. The X/Y is the top left of the triangle "box", and the W/H is the width and height of it. The bottomleft of the triangle is (x,y+h-1), bottom right is (x+w-1,y+h-1), and the top is (x+w/2,y)
-- @tparam number x X coordinate of the triangle.
-- @tparam number y Y coordinate of the triangle.
-- @tparam number w Width of the triangle.
-- @tparam number h Height of the triangle.
-- @tparam number col Colour of the triangle.
function shape.triangle(x, y, w, h, col)
    expect(1, x, "number")
    expect(2, y, "number")
    expect(3, w, "number")
    expect(4, h, "number")
    expect(5, col, "number")

    local oX, oY = term.getCursorPos()
    local oCol = term.getBackgroundColour() -- restore stuff after painutils

    paintutils.drawLine(x, y + h - 1, x + math.floor(w / 2), y, col)
    paintutils.drawLine(x + w - 1, y + h - 1, x + math.floor(w / 2), y, col)
    paintutils.drawLine(x, y + h - 1, x + w - 1, y + h - 1, col)

    term.setCursorPos(oX, oY)
    term.setBackgroundColour(oCol)
end

--- Draw a filled triangle. This has no gauruntee of working correctly.
-- @tparam number x X coordinate of the triangle.
-- @tparam number y Y coordinate of the triangle.
-- @tparam number w Width of the triangle.
-- @tparam number h Height of the triangle.
-- @tparam number col Colour of the triangle.
function shape.filledTriangle(x, y, w, h, col)
    expect(1, x, "number")
    expect(2, y, "number")
    expect(3, w, "number")
    expect(4, h, "number")
    expect(5, col, "number")

    for i = 1, math.floor(h / 2) do
        shape.triangle(x + i, y + i, w - i, h - i, col)
    end
end

--- Draws an ellipses.
-- @tparam number x The center X of the ellipses.
-- @tparam number y The center Y of the ellipses.
-- @tparam number width Width of the ellipses in pixels.
-- @tparam number height Height of the ellipses in pixels.
-- @tparam number colour Colour of the ellipses.
function shape.ellipses(centerX, centerY, width, height, colour)
    local x1, y1 = centerX - math.floor(width / 2), centerY - math.floor(height / 2)
    local x2, y2 = centerX + math.ceil(width / 2), centerY + math.ceil(height / 2)

    for y = y1, y2 do
        for x = x1, x2 do
            if (((x - centerX) ^ 2 / (width / 2) ^ 2 + (y - centerY) ^ 2 / (height / 2) ^ 2) <= 1.1) and
                (((x - centerX) ^ 2 / (width / 2) ^ 2 + (y - centerY) ^ 2 / (height / 2) ^ 2) >= 0.95) then
                paintutils.drawPixel(x, y, colour)
            end
        end
    end
end

function shape.drawButton(x, y, width, height, borderColor, highlightColor, innerColor, backgroundColor)
    width = width - 1
    height = height - 1
    shape.drawFilledBox(x, y - 1, 1, 1, borderColor, "\159", backgroundColor) -- upper right border
    shape.drawFilledBox(x, y, 1, 1, borderColor, "\149", backgroundColor) -- left border
    shape.drawFilledBox(x + 1, y, 1, 1, innerColor, "\151", highlightColor) -- left corner highlight
    shape.drawFilledBox(x + 1, y - 1, width - 1, 1, borderColor, "\143", backgroundColor) -- upper border
    shape.drawFilledBox(x + 2, y, width - 2, 1, innerColor, "\131", highlightColor) -- upper highlight
    shape.drawFilledBox(x + width, y - 1, 1, 1, backgroundColor, "\144", borderColor) -- right border
    shape.drawFilledBox(x + width, y, 1, 1, backgroundColor, "\149", borderColor) -- upper right corner
    for i = 1, height + 1 do
        shape.drawFilledBox(x, y + i, 1, 1, borderColor, "\149", backgroundColor) -- left border
        shape.drawFilledBox(x + 1, y + i, 1, 1, innerColor, "\149", highlightColor) -- left highlight
        shape.drawFilledBox(x + 2, y + i, width - 2, 1, innerColor) -- inner area
        shape.drawFilledBox(x + width, y + i, 1, 1, backgroundColor, "\149", borderColor) -- right border
    end
    shape.drawFilledBox(x, y + height + 1, 1, 1, backgroundColor, "\130", borderColor) -- bottom left corner
    shape.drawFilledBox(x + 1, y + height + 1, width, 1, backgroundColor, "\131", borderColor) -- bottom border
    shape.drawFilledBox(x + width, y + height + 1, 1, 1, backgroundColor, "\129", borderColor) -- bottom Right Corner
end

--- Draws a filled ellipses.
-- @tparam number x The center X of the ellipses.
-- @tparam number y The center Y of the ellipses.
-- @tparam number width Width of the ellipses in pixels.
-- @tparam number height Height of the ellipses in pixels.
-- @tparam number colour Colour of the ellipses.
function shape.filledEllipses(centerX, centerY, width, height, colour)
    local x1, y1 = centerX - math.floor(width / 2), centerY - math.floor(height / 2)
    local x2, y2 = centerX + math.ceil(width / 2), centerY + math.ceil(height / 2)

    for y = y1, y2 do
        for x = x1, x2 do
            if ((x - centerX) ^ 2 / (width / 2) ^ 2) + ((y - centerY) ^ 2 / (height / 2) ^ 2) <= 1 then
                paintutils.drawPixel(x, y, colour)
            end
        end
    end
end

return shape

