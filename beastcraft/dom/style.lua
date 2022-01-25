local class = require("beastcraft.core.class")

local Style = class({
    zIndex = 1,
    display = "block",
    top = 0,
    left = 0,
    bottom = 0,
    right = 0,
    width = 0,
    height = 0,
    minWidth = 0,
    minHeight = 0,
    maxWidth = 'auto',
    maxHeight = 'auto',
    paddingLeft = 0,
    paddingTop = 0,
    paddingRight = 0,
    paddingBottom = 0,
    marginLeft = 0,
    marginTop = 0,
    marginRight = 0,
    marginBottom = 0,
    backgroundColor = "transparent",
    color = colors.black,
    position = "relative",
    margin = function(self, val)
        self.marginTop = val
        self.marginLeft = val
        self.marginRight = val
        self.marginBottom = val
    end,
    padding = function(self, val)
        self.paddingTop = val
        self.paddingLeft = val
        self.paddingRight = val
        self.paddingBottom = val
    end,
    constructor = function(self, styles)
        for k, v in pairs(styles) do
            self[k] = v
        end
    end
})

return Style

