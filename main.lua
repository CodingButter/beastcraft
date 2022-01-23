local document = require"beastcraft".document
local renderDom = require"beastcraft".ui.renderDom
local App = require "src.app"

local body = document.body
renderDom(App, body)
