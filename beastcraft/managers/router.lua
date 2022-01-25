local state = require "beastcraft.managers.state"
local routerContext = state.createContext({})
local div = require"beastcraft.ui".div
local debugger = require"beastcraft.core.utils".debugger
local Router = function(props)
    local page, setPage = state.useState(props.default)

    return routerContext.Provider({
        value = {page, setPage},
        children = function()
            local pages = {}
            for k, v in pairs(props.pages) do
                pages[#pages + 1] = div({
                    style = {
                        display = page == k and "block" or "none"
                    },
                    children = {v()}
                })
            end
            return pages
        end
    })
end

return {
    Router = Router,
    routerContext = routerContext
}
