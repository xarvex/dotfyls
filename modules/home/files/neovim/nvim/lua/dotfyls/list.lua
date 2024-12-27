local M = {}

function M.into_set(table)
    local set = {}
    for _, value in pairs(table) do
        set[value] = true
    end

    return set
end

function M.append(list, ...)
    for i = 1, select("#", ...) do
        list[#list + 1] = select(i, ...)
    end
end

return M
