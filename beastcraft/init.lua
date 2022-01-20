BEASTCRAFT_ROOT = fs.getDir(shell.getRunningProgram()) .. ".beastcraft."
local utils = require(BEASTCRAFT_ROOT .. "core.Utils")

return {
    document = require(BEASTCRAFT_ROOT .. "dom"),
    ui = require(BEASTCRAFT_ROOT .. "ui"),
    state = require(BEASTCRAFT_ROOT .. "managers.state"),
    class = require(BEASTCRAFT_ROOT .. "core.class")
}
