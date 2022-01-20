local beastcraft = require "beastcraft"
local body = beastcraft.document.body
local App = require "src.App"
local debugger = require"beastcraft.core.Utils".debugger

beastcraft.ui.renderDom(App(), body)
