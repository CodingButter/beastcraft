-- +--------------------------------------------------------+
-- |                                                        |
-- |                        BLittle                         |
-- |                                                        |
-- +--------------------------------------------------------+
local version = "Version 1.1.6beta"

-- By Jeffrey Alexander, aka Bomb Bloke.
-- Convenience functions to make use of ComputerCraft 1.76's new "drawing" characters.
-- http://www.computercraft.info/forums2/index.php?/topic/25354-cc-176-blittle-api/

-------------------------------------------------------------

if shell then
    local arg = {...}

    if #arg == 0 then
        print("Usage:")
        print("blittle <scriptName> [args]")
        return
    end

    if not blittle then
        os.loadAPI(shell.getRunningProgram())
    end
    local oldTerm = term.redirect(blittle.createWindow())
    shell.run(unpack(arg))
    term.redirect(oldTerm)

    return
end

local relations = {
    [0] = {8, 4, 3, 6, 5},
    {4, 14, 8, 7},
    {6, 10, 8, 7},
    {9, 11, 8, 0},
    {1, 14, 8, 0},
    {13, 12, 8, 0},
    {2, 10, 8, 0},
    {15, 8, 10, 11, 12, 14},
    {0, 7, 1, 9, 2, 13},
    {3, 11, 8, 7},
    {2, 6, 7, 15},
    {9, 3, 7, 15},
    {13, 5, 7, 15},
    {5, 12, 8, 7},
    {1, 4, 7, 15},
    {7, 10, 11, 12, 14}
}

local colourNum, exponents, colourChar = {}, {}, {}
for i = 0, 15 do
    exponents[2 ^ i] = i
end
do
    local hex = "0123456789abcdef"
    for i = 1, 16 do
        colourNum[hex:sub(i, i)] = i - 1
        colourNum[i - 1] = hex:sub(i, i)
        colourChar[hex:sub(i, i)] = 2 ^ (i - 1)
        colourChar[2 ^ (i - 1)] = hex:sub(i, i)

        local thisRel = relations[i - 1]
        for i = 1, #thisRel do
            thisRel[i] = 2 ^ thisRel[i]
        end
    end
end

local function getBestColourMatch(usage)
    local lastCol = relations[exponents[usage[#usage][1]]]

    for j = 1, #lastCol do
        local thisRelation = lastCol[j]
        for i = 1, #usage - 1 do
            if usage[i][1] == thisRelation then
                return i
            end
        end
    end

    return 1
end

local function colsToChar(pattern, totals)
    if not totals then
        local newPattern = {}
        totals = {}
        for i = 1, 6 do
            local thisVal = pattern[i]
            local thisTot = totals[thisVal]
            totals[thisVal], newPattern[i] = thisTot and (thisTot + 1) or 1, thisVal
        end
        pattern = newPattern
    end

    local usage = {}
    for key, value in pairs(totals) do
        usage[#usage + 1] = {key, value}
    end

    if #usage > 1 then
        -- Reduce the chunk to two colours:
        while #usage > 2 do
            table.sort(usage, function(a, b)
                return a[2] > b[2]
            end)
            local matchToInd, usageLen = getBestColourMatch(usage), #usage
            local matchFrom, matchTo = usage[usageLen][1], usage[matchToInd][1]
            for i = 1, 6 do
                if pattern[i] == matchFrom then
                    pattern[i] = matchTo
                    usage[matchToInd][2] = usage[matchToInd][2] + 1
                end
            end
            usage[usageLen] = nil
        end

        -- Convert to character. Adapted from oli414's function:
        -- http://www.computercraft.info/forums2/index.php?/topic/25340-cc-176-easy-drawing-characters/
        local data = 128
        for i = 1, #pattern - 1 do
            if pattern[i] ~= pattern[6] then
                data = data + 2 ^ (i - 1)
            end
        end
        return string.char(data), colourChar[usage[1][1] == pattern[6] and usage[2][1] or usage[1][1]],
            colourChar[pattern[6]]
    else
        -- Solid colour character:
        return "\128", colourChar[pattern[1]], colourChar[pattern[1]]
    end
end

local function snooze()
    local myEvent = tostring({})
    os.queueEvent(myEvent)
    os.pullEvent(myEvent)
end

function shrink(image, bgCol)
    local results, width, height, bgCol = {{}, {}, {}}, 0, #image + #image % 3, bgCol or colours.black
    for i = 1, #image do
        if #image[i] > width then
            width = #image[i]
        end
    end

    for y = 0, height - 1, 3 do
        local cRow, tRow, bRow, counter = {}, {}, {}, 1

        for x = 0, width - 1, 2 do
            -- Grab a 2x3 chunk:
            local pattern, totals = {}, {}

            for yy = 1, 3 do
                for xx = 1, 2 do
                    pattern[#pattern + 1] = (image[y + yy] and image[y + yy][x + xx]) and
                                                (image[y + yy][x + xx] == 0 and bgCol or image[y + yy][x + xx]) or bgCol
                    totals[pattern[#pattern]] = totals[pattern[#pattern]] and (totals[pattern[#pattern]] + 1) or 1
                end
            end

            cRow[counter], tRow[counter], bRow[counter] = colsToChar(pattern, totals)
            counter = counter + 1
        end

        results[1][#results[1] + 1], results[2][#results[2] + 1], results[3][#results[3] + 1] = table.concat(cRow),
            table.concat(tRow), table.concat(bRow)
    end

    results.width, results.height = #results[1][1], #results[1]

    return results
end

function shrinkGIF(image, bgCol)
    if not GIF and not os.loadAPI("GIF") then
        error("blittle.shrinkGIF: Load GIF API first.", 2)
    end

    image = GIF.flattenGIF(image)
    snooze()

    local prev = GIF.toPaintutils(image[1])
    snooze()

    prev = blittle.shrink(prev, bgCol)
    prev.delay = image[1].delay
    image[1] = prev
    snooze()

    image.width, image.height = prev.width, prev.height

    for i = 2, #image do
        local temp = GIF.toPaintutils(image[i])
        snooze()

        temp = blittle.shrink(temp, bgCol)
        snooze()

        local newImage = {
            {},
            {},
            {},
            ["delay"] = image[i].delay,
            ["width"] = temp.width,
            ["height"] = 0
        }

        local a, b, c, pa, pb, pc = temp[1], temp[2], temp[3], prev[1], prev[2], prev[3]
        for i = 1, temp.height do
            local a1, b1, c1, pa1, pb1, pc1 = a[i], b[i], c[i], pa[i], pb[i], pc[i]

            if a1 ~= pa1 or b1 ~= pb1 or c1 ~= pc1 then
                local min, max = 1, #a1
                local a2, b2, c2, pa2, pb2, pc2 = {a1:byte(1, max)}, {b1:byte(1, max)}, {c1:byte(1, max)},
                    {pa1:byte(1, max)}, {pb1:byte(1, max)}, {pc1:byte(1, max)}

                for j = 1, max do
                    if a2[j] ~= pa2[j] or b2[j] ~= pb2[j] or c2[j] ~= pc2[j] then
                        min = j
                        break
                    end
                end

                for j = max, min, -1 do
                    if a2[j] ~= pa2[j] or b2[j] ~= pb2[j] or c2[j] ~= pc2[j] then
                        max = j
                        break
                    end
                end

                newImage[1][i], newImage[2][i], newImage[3][i], newImage.height = min > 1 and
                                                                                      {min - 1, a1:sub(min, max)} or
                                                                                      a1:sub(min, max),
                    b1:sub(min, max), c1:sub(min, max), i
            end

            snooze()
        end

        image[i], prev = newImage, temp

        for j = 1, i - 1 do
            local oldImage = image[j]

            if type(oldImage[1]) == "table" and oldImage.height == newImage.height then
                local same = true

                for k = 1, oldImage.height do
                    local comp1, comp2 = oldImage[1][k], newImage[1][k]

                    if type(comp1) ~= type(comp2) or (type(comp1) == "string" and comp1 ~= comp2) or
                        (type(comp1) == "table" and (comp1[1] ~= comp2[1] or comp1[2] ~= comp2[2])) or oldImage[2][k] ~=
                        newImage[2][k] or oldImage[3][k] ~= newImage[3][k] then
                        same = false
                        break
                    end
                end

                if same then
                    newImage[1], newImage[2], newImage[3] = j
                    break
                end
            end

            snooze()
        end
    end

    return image
end

local function newLine(width, bCol)
    local line = {}
    for i = 1, width do
        line[i] = {bCol, bCol, bCol, bCol, bCol, bCol}
    end
    return line
end

function createWindow(parent, x, y, width, height, visible)
    if parent == term or not parent then
        parent = term.current()
    elseif type(parent) ~= "table" or not parent.write then
        error("blittle.newWindow: \"parent\" does not appear to be a terminal object.", 2)
    end

    local workBuffer, backBuffer, frontBuffer, window, tCol, bCol, curX, curY, blink, cWidth, cHeight, pal = {}, {}, {},
        {}, colours.white, colours.black, 1, 1, false
    if type(visible) ~= "boolean" then
        visible = true
    end
    x, y = x and math.floor(x) or 1, y and math.floor(y) or 1

    do
        local xSize, ySize = parent.getSize()
        cWidth, cHeight = (width or xSize), (height or ySize)
        width, height = cWidth * 2, cHeight * 3
    end

    if parent.setPaletteColour then
        pal = {}

        local counter = 1
        for i = 1, 16 do
            pal[counter] = {parent.getPaletteColour(counter)}
            counter = counter * 2
        end

        window.getPaletteColour = function(colour)
            return unpack(pal[colour])
        end

        window.setPaletteColour = function(colour, r, g, b)
            pal[colour] = {r, g, b}
            if visible then
                return parent.setPaletteColour(colour, r, g, b)
            end
        end

        window.getPaletteColor, window.setPaletteColor = window.getPaletteColour, window.setPaletteColour
    end

    window.blit = function(_, _, bC)
        local bClen = #bC
        if curX > width or curX + bClen < 2 or curY < 1 or curY > height then
            curX = curX + bClen
            return
        end

        if curX < 1 then
            bC = bC:sub(2 - curX)
            curX, bClen = 1, #bC
        end

        if curX + bClen - 1 > width then
            bC, bClen = bC:sub(1, width - curX + 1), width - curX + 1
        end

        local colNum, rowNum, thisX, yBump = math.floor((curX - 1) / 2) + 1, math.floor((curY - 1) / 3) + 1,
            (curX - 1) % 2, ((curY - 1) % 3) * 2
        local firstColNum, lastColNum, thisRow = colNum, math.floor((curX + bClen) / 2), backBuffer[rowNum]
        local thisChar = thisRow[colNum]

        for i = 1, bClen do
            thisChar[thisX + yBump + 1] = colourChar[bC:sub(i, i)]

            if thisX == 1 then
                thisX, colNum = 0, colNum + 1
                thisChar = thisRow[colNum]
                if not thisChar then
                    break
                end
            else
                thisX = 1
            end
        end

        if visible then
            local chars1, chars2, chars3, count = {}, {}, {}, 1

            for i = firstColNum, lastColNum do
                chars1[count], chars2[count], chars3[count] = colsToChar(thisRow[i])
                count = count + 1
            end

            chars1, chars2, chars3 = table.concat(chars1), table.concat(chars2), table.concat(chars3)
            parent.setCursorPos(x + math.floor((curX - 1) / 2), y + math.floor((curY - 1) / 3))
            parent.blit(chars1, chars2, chars3)
            local thisRow = frontBuffer[rowNum]
            frontBuffer[rowNum] = {thisRow[1]:sub(1, firstColNum - 1) .. chars1 .. thisRow[1]:sub(lastColNum + 1),
                                   thisRow[2]:sub(1, firstColNum - 1) .. chars2 .. thisRow[2]:sub(lastColNum + 1),
                                   thisRow[3]:sub(1, firstColNum - 1) .. chars3 .. thisRow[3]:sub(lastColNum + 1)}
        else
            local thisRow = workBuffer[rowNum]

            if (not thisRow[firstColNum]) or thisRow[firstColNum] < lastColNum then
                local x, newLastColNum = 1, lastColNum

                while x <= lastColNum + 1 do
                    local thisSpot = thisRow[x]

                    if thisSpot then
                        if thisSpot >= firstColNum - 1 then
                            if x < firstColNum then
                                firstColNum = x
                            else
                                thisRow[x] = nil
                            end
                            if thisSpot > newLastColNum then
                                newLastColNum = thisSpot
                            end
                        end
                        x = thisSpot + 1
                    else
                        x = x + 1
                    end
                end

                thisRow[firstColNum] = newLastColNum
                if thisRow.max <= newLastColNum then
                    thisRow.max = firstColNum
                end
            end
        end

        curX = curX + bClen
    end

    window.write = function(text)
        window.blit(nil, nil, string.rep(colourChar[bCol], #tostring(text)))
    end

    window.clearLine = function()
        local oldX = curX
        curX = 1
        window.blit(nil, nil, string.rep(colourChar[bCol], width))
        curX = oldX
    end

    window.clear = function()
        local t, fC, bC = string.rep("\128", cWidth), string.rep(colourChar[tCol], cWidth),
            string.rep(colourChar[bCol], cWidth)
        for y = 1, cHeight do
            workBuffer[y], backBuffer[y], frontBuffer[y] = {
                ["max"] = 0
            }, newLine(cWidth, bCol), {t, fC, bC}
        end
        window.redraw()
    end

    window.getCursorPos = function()
        return curX, curY
    end

    window.setCursorPos = function(newX, newY)
        curX, curY = math.floor(newX), math.floor(newY)
        if visible and blink then
            window.restoreCursor()
        end
    end

    window.restoreCursor = function()
    end
    window.setCursorBlink = window.restoreCursor

    window.isColour = function()
        return parent.isColour()
    end
    window.isColor = window.isColour

    window.getSize = function()
        return width, height
    end

    window.scroll = function(lines)
        lines = math.floor(lines)

        if lines ~= 0 then
            if lines % 3 == 0 then
                local newWB, newBB, newFB, line1, line2, line3 = {}, {}, {}, string.rep("\128", cWidth),
                    string.rep(colourChar[tCol], cWidth), string.rep(colourChar[bCol], cWidth)
                for y = 1, cHeight do
                    newWB[y], newBB[y], newFB[y] = workBuffer[y + lines] or {
                        ["max"] = 0
                    }, backBuffer[y + lines] or newLine(cWidth, bCol), frontBuffer[y + lines] or {line1, line2, line3}
                end
                workBuffer, backBuffer, frontBuffer = newWB, newBB, newFB
            else
                local newBB, tRowNum, tBump, sRowNum, sBump = {}, 1, 0, math.floor(lines / 3) + 1, (lines % 3) * 2
                local sRow, tRow = backBuffer[sRowNum], {}
                for x = 1, cWidth do
                    tRow[x] = {}
                end

                for y = 1, height do
                    if sRow then
                        for x = 1, cWidth do
                            local tChar, sChar = tRow[x], sRow[x]
                            tChar[tBump + 1], tChar[tBump + 2] = sChar[sBump + 1], sChar[sBump + 2]
                        end
                    else
                        for x = 1, cWidth do
                            local tChar = tRow[x]
                            tChar[tBump + 1], tChar[tBump + 2] = bCol, bCol
                        end
                    end

                    tBump, sBump = tBump + 2, sBump + 2

                    if tBump > 4 then
                        tBump, newBB[tRowNum] = 0, tRow
                        tRowNum, tRow = tRowNum + 1, {}
                        for x = 1, cWidth do
                            tRow[x] = {}
                        end
                    end

                    if sBump > 4 then
                        sRowNum, sBump = sRowNum + 1, 0
                        sRow = backBuffer[sRowNum]
                    end
                end

                for y = 1, cHeight do
                    workBuffer[y] = {
                        ["max"] = 1,
                        cWidth
                    }
                end

                backBuffer = newBB
            end

            window.redraw()
        end
    end

    window.setTextColour = function(newCol)
        tCol = newCol
    end
    window.setTextColor = window.setTextColour

    window.setBackgroundColour = function(newCol)
        bCol = newCol
    end
    window.setBackgroundColor = window.setBackgroundColour

    window.getTextColour = function()
        return tCol
    end
    window.getTextColor = window.getTextColour

    window.getBackgroundColour = function()
        return bCol
    end
    window.getBackgroundColor = window.getBackgroundColour

    window.redraw = function()
        if visible then
            for i = 1, cHeight do
                local work, front = workBuffer[i], frontBuffer[i]
                local front1, front2, front3 = front[1], front[2], front[3]

                if work.max > 0 then
                    local line1, line2, line3, lineLen, skip, back, count = {}, {}, {}, 1, 0, backBuffer[i], 1

                    while count <= work.max do
                        if work[count] then
                            if skip > 0 then
                                line1[lineLen], line2[lineLen], line3[lineLen] = front1:sub(count - skip, count - 1),
                                    front2:sub(count - skip, count - 1), front3:sub(count - skip, count - 1)
                                skip, lineLen = 0, lineLen + 1
                            end

                            for i = count, work[count] do
                                line1[lineLen], line2[lineLen], line3[lineLen] = colsToChar(back[i])
                                lineLen = lineLen + 1
                            end

                            count = work[count] + 1
                        else
                            skip, count = skip + 1, count + 1
                        end
                    end

                    if count < cWidth + 1 then
                        line1[lineLen], line2[lineLen], line3[lineLen] = front1:sub(count), front2:sub(count),
                            front3:sub(count)
                    end

                    front1, front2, front3 = table.concat(line1), table.concat(line2), table.concat(line3)
                    frontBuffer[i], workBuffer[i] = {front1, front2, front3}, {
                        ["max"] = 0
                    }
                end

                parent.setCursorPos(x, y + i - 1)
                parent.blit(front1, front2, front3)
            end

            if pal then
                local counter = 1
                for i = 1, 16 do
                    parent.setPaletteColour(counter, unpack(pal[counter]))
                    counter = counter * 2
                end
            end
        end
    end

    window.setVisible = function(newVis)
        newVis = newVis and true or false

        if newVis and not visible then
            visible = true
            window.redraw()
        else
            visible = newVis
        end
    end

    window.getPosition = function()
        return x, y
    end

    window.reposition = function(newX, newY, newWidth, newHeight)
        x, y = type(newX) == "number" and math.floor(newX) or x, type(newY) == "number" and math.floor(newY) or y

        if type(newWidth) == "number" then
            newWidth = math.floor(newWidth)
            if newWidth > cWidth then
                local line1, line2, line3 = string.rep("\128", newWidth - cWidth),
                    string.rep(colourChar[tCol], newWidth - cWidth), string.rep(colourChar[bCol], newWidth - cWidth)
                for y = 1, cHeight do
                    local bRow, fRow = backBuffer[y], frontBuffer[y]
                    for x = cWidth + 1, newWidth do
                        bRow[x] = {bCol, bCol, bCol, bCol, bCol, bCol}
                    end
                    frontBuffer[y] = {fRow[1] .. line3, fRow[2] .. line2, fRow[3] .. line3}
                end
            elseif newWidth < cWidth then
                for y = 1, cHeight do
                    local wRow, bRow, fRow = workBuffer[y], backBuffer[y], frontBuffer[y]
                    for x = newWidth + 1, cWidth do
                        bRow[x] = nil
                    end
                    frontBuffer[y] = {fRow[1]:sub(1, newWidth), fRow[2]:sub(1, newWidth), fRow[3]:sub(1, newWidth)}

                    while wRow[wRow.max] and wRow[wRow.max] > newWidth do
                        wRow[wRow.max] = nil
                        wRow.max = table.maxn(wRow)
                    end
                end
            end
            width, cWidth = newWidth * 2, newWidth
        end

        if type(newHeight) == "number" then
            newHeight = math.floor(newHeight)
            if newHeight > cHeight then
                local line1, line2, line3 = string.rep("\128", cWidth), string.rep(colourChar[tCol], cWidth),
                    string.rep(colourChar[bCol], cWidth)
                for y = cHeight + 1, newHeight do
                    workBuffer[y], backBuffer[y], frontBuffer[y] = {
                        ["max"] = 0
                    }, newLine(cWidth, bCol), {line1, line2, line3}
                end
            elseif newHeight < cHeight then
                for y = newHeight + 1, cHeight do
                    workBuffer[y], backBuffer[y], frontBuffer[y] = nil, nil, nil
                end
            end
            height, cHeight = newHeight * 3, newHeight
        end

        window.redraw()
    end

    window.clear()
    return window
end

function draw(image, x, y, terminal)
    local t, tC, bC = image[1], image[2], image[3]
    x, y, terminal = x or 1, y or 1, terminal or term.current()

    for i = 1, image.height do
        local tI = t[i]
        if type(tI) == "string" then
            terminal.setCursorPos(x, y + i - 1)
            terminal.blit(tI, tC[i], bC[i])
        elseif type(tI) == "table" then
            terminal.setCursorPos(x + tI[1], y + i - 1)
            terminal.blit(tI[2], tC[i], bC[i])
        end
    end
end

function save(image, filename)
    local output = fs.open(filename, "wb")
    if not output then
        error("Can't open " .. filename .. " for output.")
    end

    local writeByte = output.write

    local function writeInt(num)
        writeByte(bit.band(num, 255))
        writeByte(bit.brshift(num, 8))
    end

    writeByte(66) -- B
    writeByte(76) -- L
    writeByte(84) -- T

    local animated = image[1].delay ~= nil
    writeByte(animated and 1 or 0)

    if animated then
        writeInt(#image)
    else
        local tempImage = {image[1], image[2], image[3]}
        image[1], image[2], image[3] = tempImage, nil, nil
    end

    local width, height = image.width, image.height

    writeInt(width)
    writeInt(height)

    for k = 1, #image do
        local thisImage = image[k]

        if type(thisImage[1]) == "number" then
            writeByte(3)
            writeInt(thisImage[1])
        else
            for i = 1, height do
                if thisImage[1][i] then
                    local rowType, len, thisRow = type(thisImage[1][i])

                    if rowType == "string" then
                        writeByte(1)
                        len = #thisImage[1][i]
                        writeInt(len)
                        thisRow = {thisImage[1][i]:byte(1, len)}
                    elseif rowType == "table" then
                        writeByte(2)
                        len = #thisImage[1][i][2]
                        writeInt(len)
                        writeInt(thisImage[1][i][1])
                        thisRow = {thisImage[1][i][2]:byte(1, len)}
                    else
                        error("Malformed row record #" .. i .. " in frame #" .. k .. " when attempting to save \"" ..
                                  filename .. "\", type is " .. rowType .. ".")
                    end

                    for x = 1, len do
                        writeByte(thisRow[x])
                    end

                    local txt, bg = thisImage[2][i], thisImage[3][i]
                    for x = 1, len do
                        writeByte(colourNum[txt:sub(x, x)] + colourNum[bg:sub(x, x)] * 16)
                    end
                else
                    writeByte(0)
                end
            end
        end

        if animated then
            writeInt(thisImage.delay * 20)
        end

        snooze()
    end

    if image.pal then
        writeByte(#image.pal)
        for i = 0, #image.pal do
            for j = 1, 3 do
                writeByte(image.pal[i][j])
            end
        end
    end

    if not animated then
        image[2], image[3] = image[1][2], image[1][3]
        image[1] = image[1][1]
    end

    output.close()
end

function load(filename)
    local input = fs.open(filename, "rb")
    if not input then
        error("Can't open " .. filename .. " for input.")
    end

    local read = input.read

    local function readInt()
        local result = read()
        return result + bit.blshift(read(), 8)
    end

    if string.char(read(), read(), read()) ~= "BLT" then
        -- Assume legacy format.
        input.close()
        input = fs.open(filename, "rb")

        read = input.read

        function readInt()
            local result = input.read()
            return result + bit.blshift(input.read(), 8)
        end

        local image = {}
        image.width, image.height = readInt(), readInt()

        for i = 1, 3 do
            local thisSet = {}
            for y = 1, image.height do
                local thisRow = {}
                for x = 1, image.width do
                    thisRow[x] = string.char(input.read())
                end
                thisSet[y] = table.concat(thisRow)
            end
            image[i] = thisSet
        end

        input.close()

        return image
    end

    local image, animated, frames = {}, read() == 1
    if animated then
        frames = readInt()
    else
        frames = 1
    end

    local width, height = readInt(), readInt()
    image.width, image.height = width, height

    for k = 1, frames do
        local thisImage = {
            ["width"] = width,
            ["height"] = 0
        }
        local chr, txt, bg = {}, {}, {}

        for i = 1, height do
            local lineType = read()

            if lineType == 3 then
                chr, txt, bg = readInt()
                break
            elseif lineType > 0 then
                local l1, l2, len, bump = {}, {}, readInt()
                if lineType == 2 then
                    bump = readInt()
                end

                for x = 1, len do
                    l1[x] = read()
                end
                chr[i] = string.char(unpack(l1))
                if lineType == 2 then
                    chr[i] = {bump, chr[i]}
                end

                for x = 1, len do
                    local thisVal = read()
                    l1[x], l2[x] = colourNum[bit.band(thisVal, 15)], colourNum[bit.brshift(thisVal, 4)]
                end

                txt[i], bg[i], thisImage.height = table.concat(l1), table.concat(l2), i
            end
        end

        if animated then
            thisImage["delay"] = readInt() / 20
        end
        thisImage[1], thisImage[2], thisImage[3] = chr, txt, bg
        image[k] = thisImage

        snooze()
    end

    local palLength = read()
    if palLength and palLength > 0 then
        image.pal = {}
        for i = 0, palLength do
            image.pal[i] = {read(), read(), read()}
        end
    end

    if not animated then
        image[2], image[3] = image[1][2], image[1][3]
        image[1] = image[1][1]
    end

    input.close()

    return image
end

if term.setPaletteColour then
    function applyPalette(image, terminal)
        terminal = terminal or term

        local col, pal = 1, image.pal

        for i = 0, #pal do
            local thisCol = pal[i]
            terminal.setPaletteColour(col, thisCol[1] / 255, thisCol[2] / 255, thisCol[3] / 255)
            col = col * 2
        end
    end
end
