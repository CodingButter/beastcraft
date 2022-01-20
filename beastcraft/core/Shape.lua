--- Draw various shapes on the screen.
-- @module[kind=gui] Shape
local utils = require(BEASTCRAFT_ROOT .. "core.Utils")
local shape = {}
local expect = require("cc.expect").expect
local myWindow = utils.window

--- Draw a filled rectangle.
-- @tparam number x X coordinate of rectangle.
-- @tparam number y Y coordinate of rectangle.
-- @tparam number w Width of rectangle.
-- @tparam number h Height of rectangle.
-- @tparam number|string col Colour of rectangle, accepts blit or `colours.` colour.
function shape.drawFilledBox(x, y, w, h, col)
    expect(1, x, "number")
    expect(2, y, "number")
    expect(3, w, "number")
    expect(4, h, "number")
    expect(5, col, "number", "string")
    if type(col) == "number" then
        col = colours.toBlit(col)
    end

    for i = 1, h do
        myWindow.setCursorPos(x, y + i - 1)
        myWindow.blit((" "):rep(w), col:rep(w), col:rep(w))
    end
end

--- Draw a hollow rectangle.
-- @tparam number x X coordinate of rectangle.
-- @tparam number y Y coordinate of rectangle.
-- @tparam number w Width of rectangle.
-- @tparam number h Height of rectangle.
-- @tparam number|string col Colour of rectangle, accepts blit or `colours.` colour.
function shape.rectangle(x, y, w, h, col)
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
            myWindow.setCursorPos(x, y + i - 1)
            myWindow.blit((" "):rep(w), col:rep(w), col:rep(w))
        else
            myWindow.setCursorPos(x, y + i - 1)
            myWindow.blit(" ", col, col)
            myWindow.setCursorPos(x + w - 1, y + i - 1)
            myWindow.blit(" ", col, col)
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

    local oX, oY = myWindow.getCursorPos()
    local oCol = myWindow.getBackgroundColour() -- restore stuff after painutils

    paintutils.drawLine(x, y + h - 1, x + math.floor(w / 2), y, col)
    paintutils.drawLine(x + w - 1, y + h - 1, x + math.floor(w / 2), y, col)
    paintutils.drawLine(x, y + h - 1, x + w - 1, y + h - 1, col)

    myWindow.setCursorPos(oX, oY)
    myWindow.setBackgroundColour(oCol)
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

