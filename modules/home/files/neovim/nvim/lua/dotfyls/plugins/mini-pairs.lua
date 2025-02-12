---@module "lazy"
---@type LazySpec
return {
    "echasnovski/mini.pairs",
    event = { "BufNewFile", "BufReadPost" },
    opts = function()
        local pairs_open = require("mini.pairs").open
        ---@diagnostic disable-next-line: duplicate-set-field
        require("mini.pairs").open = function(pair, neigh_pattern)
            if vim.fn.getcmdline() == "" then
                local open = pair:sub(1, 1)
                local line = vim.api.nvim_get_current_line()
                local cursor = vim.api.nvim_win_get_cursor(0)
                local before = line:sub(1, cursor[2])

                if open == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
                    return "`\n```" .. vim.api.nvim_replace_termcodes("<Up>", true, true, true)
                end

                local next = line:sub(cursor[2] + 1, cursor[2] + 1)
                if next ~= "" and next:match([=[[%w%%%'%[%"%.%`%$]]=]) then return open end

                local ok_captures, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
                if ok_captures then
                    for _, capture in ipairs(captures) do
                        if vim.tbl_contains({ "string" }, capture.capture) then return open end
                    end
                end

                local close = pair:sub(2, 2)
                if close == next and close ~= open then
                    local _, count_open = line:gsub(vim.pesc(open), "")
                    local _, count_close = line:gsub(vim.pesc(close), "")
                    if count_close > count_open then return open end
                end
            end

            return pairs_open(pair, neigh_pattern)
        end

        return {
            modes = { insert = true, command = true, terminal = false },
        }
    end,
}
