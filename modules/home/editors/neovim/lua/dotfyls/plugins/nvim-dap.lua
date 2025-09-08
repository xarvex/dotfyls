---@module "lazy"
---@type LazySpec
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = { { "theHamsta/nvim-dap-virtual-text", opts = { highlight_new_as_changed = true } } },
        event = "LspAttach",
        keys = {
            {
                "<leader>db",
                function() require("dap").toggle_breakpoint() end,
                silent = true,
                desc = "DAP breakpoint toggle (nvim-dap)",
            },
            {
                "<leader>da",
                function()
                    require("dap").continue({
                        before = function(config)
                            local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string]]
                            local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

                            config = vim.deepcopy(config)
                            config.args = function()
                                local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str))
                                if config.type and config.type == "java" then return new_args end
                                return require("dap.utils").splitstr(new_args)
                            end

                            return config
                        end,
                    })
                end,
                desc = "DAP run with arguments (nvim-dap)",
            },
            {
                "<leader>dc",
                function() require("dap").continue() end,
                silent = true,
                desc = "DAP run/continue (nvim-dap)",
            },
            {
                "<leader>dC",
                function() require("dap").run_to_cursor() end,
                silent = true,
                desc = "DAP run to cursor (nvim-dap)",
            },
            { "<leader>dg", function() require("dap").goto_() end, silent = true, desc = "DAP goto (nvim-dap)" },
            {
                "<leader>di",
                function() require("dap").step_into() end,
                silent = true,
                desc = "DAP step into (nvim-dap)",
            },
            { "<leader>dj", function() require("dap").down() end, silent = true, desc = "DAP down (nvim-dap)" },
            { "<leader>dk", function() require("dap").up() end, silent = true, desc = "DAP up (nvim-dap)" },
            { "<leader>dl", function() require("dap").run_last() end, silent = true, desc = "DAP run last (nvim-dap)" },
            { "<leader>do", function() require("dap").step_out() end, silent = true, desc = "DAP step out (nvim-dap)" },
            {
                "<leader>dO",
                function() require("dap").step_over() end,
                silent = true,
                desc = "DAP step over (nvim-dap)",
            },
            { "<leader>dP", function() require("dap").pause() end, silent = true, desc = "DAP pause (nvim-dap)" },
            {
                "<leader>dr",
                function() require("dap").repl.toggle() end,
                silent = true,
                desc = "DAP REPL toggle (nvim-dap)",
            },
            { "<leader>ds", function() require("dap").session() end, silent = true, desc = "DAP session (nvim-dap)" },
            {
                "<leader>dt",
                function() require("dap").terminate() end,
                silent = true,
                desc = "DAP terminate (nvim-dap)",
            },
            {
                "<leader>dw",
                function() require("dap.ui.widgets").hover() end,
                silent = true,
                desc = "DAP hover (nvim-dap)",
            },
        },
        config = function()
            -- TODO: Adjust to executable with 1.11 of codelldb.
            require("dap").adapters.codelldb = {
                type = "server",
                host = "127.0.0.1",
                port = "${port}",
                executable = {
                    command = "codelldb",
                    args = { "--port", "${port}" },
                },
            }

            for _, language in ipairs({ "c", "cpp" }) do
                require("dap").configurations[language] = {
                    {
                        name = "Launch file",
                        type = "codelldb",
                        request = "launch",
                        program = function()
                            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                        end,
                        cwd = "${workspaceFolder}",
                    },
                    {
                        name = "Attach to process",
                        type = "codelldb",
                        request = "attach",
                        pid = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                }
            end
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-neotest/nvim-nio",
        event = "LspAttach",
        keys = {
            {
                "<leader>du",
                function() require("dapui").toggle({}) end,
                silent = true,
                desc = "DAP UI toggle (nvim-dap-ui)",
            },
            {
                "<leader>de",
                function() require("dapui").eval() end,
                mode = { "n", "v" },
                silent = true,
                desc = "DAP UI eval (nvim-dap-ui)",
            },
        },
        opts = function()
            require("dap").listeners.before.attach.dapui_config = require("dapui").open
            require("dap").listeners.before.launch.dapui_config = require("dapui").open

            ---@module "dapui"
            ---@type dapui.Config
            ---@diagnostic disable-next-line: missing-fields
            return {}
        end,
    },
    {
        "leoluz/nvim-dap-go",
        lazy = true,
        init = function()
            local id = nil --[[@type integer?]]
            id = vim.api.nvim_create_autocmd("LspAttach", {
                group = require("dotfyls.interop").group,
                callback = function(args)
                    if vim.bo[args.buf].filetype == "go" then
                        require("dap-go")
                        if id ~= nil then vim.api.nvim_del_autocmd(id) end
                    end
                end,
            })
        end,
        opts = {},
    },
}
