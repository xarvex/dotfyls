---@module "lazy"
---@type LazySpec
return {
    {
        "nvim-neotest/neotest",
        dependencies = "nvim-neotest/nvim-nio",
        keys = {
            {
                "<leader>tt",
                function() require("neotest").run.run(vim.fn.expand("%")) end,
                silent = true,
                desc = "Run current file (Neotest)",
            },
            { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, silent = true, desc = "Run all files (Neotest)" },
            { "<leader>tr", function() require("neotest").run.run() end, silent = true, desc = "Run nearest test (Neotest)" },
            { "<leader>tl", function() require("neotest").run.run_last() end, silent = true, desc = "Run last test (Neotest)" },
            {
                "<leader>td",
                ---@diagnostic disable-next-line: missing-fields
                function() require("neotest").run.run({ strategy = "dap" }) end,
                silent = true,
                desc = "Debug nearest test (Neotest)",
            },
            { "<leader>ts", function() require("neotest").summary.toggle() end, silent = true, desc = "Summary (Neotest)" },
            {
                "<leader>to",
                function() require("neotest").output.open({ enter = true, auto_close = true }) end,
                silent = true,
                desc = "Output (Neotest)",
            },
            {
                "<leader>tO",
                function() require("neotest").output_panel.toggle() end,
                silent = true,
                desc = "Output panel (Neotest)",
            },
            { "<leader>tS", function() require("neotest").run.stop() end, silent = true, desc = "Stop test (Neotest)" },
            {
                "<leader>tw",
                function() require("neotest").watch.toggle(vim.fn.expand("%")) end,
                silent = true,
                desc = "Watch (Neotest)",
            },
        },
        opts = function()
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                        return message
                    end,
                },
            }, vim.api.nvim_create_namespace("neotest"))

            ---@module "neotest"
            ---@type neotest.Config
            ---@diagnostic disable-next-line: missing-fields
            return {
                adapters = {
                    require("rustaceanvim.neotest"),
                    require("neotest-go")({ recursive_run = true }),
                },
                consumers = {
                    trouble = function(client)
                        client.listeners.results = function(adapter_id, results, partial)
                            if not partial then
                                local tree = assert(client:get_position(nil, { adapter = adapter_id }))

                                local failed = 0
                                for pos_id, result in pairs(results) do
                                    if result.status == "failed" and tree:get_key(pos_id) then failed = failed + 1 end
                                end
                                vim.schedule(function()
                                    local trouble = require("trouble")
                                    if trouble.is_open() then
                                        trouble.refresh()
                                        if failed == 0 then trouble.close() end
                                    end
                                end)
                            end
                        end

                        return client
                    end,
                },
                ---@diagnostic disable-next-line: missing-fields
                output = { open_on_run = true },
                ---@diagnostic disable-next-line: missing-fields
                quickfix = { open = function() require("trouble").open({ mode = "quickfix", focus = false }) end },
                ---@diagnostic disable-next-line: missing-fields
                status = { virtual_text = true },
            }
        end,
    },
    { "nvim-lua/plenary.nvim", lazy = true },
    { "nvim-neotest/neotest-go", lazy = true },
}
