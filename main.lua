local document = require"beastcraft".document
local renderDom = require"beastcraft".ui.renderDom
local App = require "src.app"
local P2P = require "p2p"
local body = document.body
local p2p = P2P:new("Evil CodingButter")
p2p:attachEventLoop(function()
    renderDom(function()
        return App({
            p2p = p2p
        })
    end, body)
end)
