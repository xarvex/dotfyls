local M = {}

---@param module_name string Module name as it would appear in a require.
---@return boolean available Availability of the module.
function M.module_available(module_name)
    if package.loaded[module_name] then
        return true
    else
        for _, searcher in ipairs(package.searchers) do
            local loader = searcher(module_name)
            if type(loader) == "function" then
                package.preload[module_name] = loader

                return true
            end
        end

        return false
    end
end

return M
