local root = fs.getDir(shell.getRunningProgram()).."/beastcraft"
local function _require(path)
    local loadPath = root..path
    return require(loadPath)(_require)
end
return {
    document = _require("/dom")
}