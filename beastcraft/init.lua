local utils = require("beastcraft.core.utils")

return {
    document = require("beastcraft.dom"),
    ui = require("beastcraft.ui"),
    workLoop = require("beastcraft.core.workloop"),
    state = require("beastcraft.managers.state"),
    class = require("beastcraft.core.class"),
    utils = require("beastcraft.core.utils"),
    router = require("beastcraft.managers.router").Router,
    routerContext = require("beastcraft.managers.router").routerContext
}
