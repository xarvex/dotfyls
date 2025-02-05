---@module "lazy"
---@type LazySpec
return {
    "luukvbaal/statuscol.nvim",
    event = "VeryLazy",
    opts = function()
        vim.o.foldcolumn = "1"

        return {
            relculright = true,
            segments = {
                {
                    text = { " ", "%s" },
                    condition = { require("statuscol.builtin").not_empty, true },
                    click = "v:lua.ScSa",
                },
                {
                    text = { require("statuscol.builtin").foldfunc, " " },
                    condition = { true, require("statuscol.builtin").not_empty },
                    click = "v:lua.ScFa",
                },
                {
                    text = { require("statuscol.builtin").lnumfunc, " " },
                    condition = { true, require("statuscol.builtin").not_empty },
                    click = "v:lua.ScLa",
                },
            },
        }
    end,
}
