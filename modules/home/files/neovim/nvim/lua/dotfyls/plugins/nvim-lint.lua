---@module "lazy"
---@type LazySpec
return {
    "mfussenegger/nvim-lint",
    event = { "BufNewFile", "BufReadPost" },
    init = function()
        if vim.fn.executable("codespell") == 1 then vim.o.spell = false end
    end,
    config = function()
        require("lint").linters_by_ft = {
            bash = { "shellcheck" },
            fish = { "fish" },
            go = { "revive" },
            lua = { "selene" },
            md = { "markdownlint-cli2" },
            nix = { "nix", "deadnix", "statix" },
            python = { "ruff", "mypy", "bandit" },
            sh = { "shellcheck" },
            sql = { "sqlfluff" },
            vala = { "vala_lint" },
            yaml = { "yamllint" },
            zsh = { "zsh" },
        }
        table.insert(
            require("lint").linters.codespell.args,
            1,
            "--config=" .. vim.fs.joinpath(require("dotfyls.files").config_dir, "codespell", ".codespellrc")
        )
        table.insert(require("lint").linters.vala_lint.args, 1, "--config=vala-lint.conf")

        local function lint(bufnr)
            local linters = vim.list_extend({ "codespell", "editorconfig-checker" }, require("lint")._resolve_linter_by_ft(vim.bo.filetype))

            local ctx = { filename = vim.api.nvim_buf_get_name(bufnr or 0) }
            ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")

            linters = vim.tbl_filter(function(name)
                local linter = require("lint").linters[name]
                return vim.fn.executable(linter.cmd) == 1
                    ---@diagnostic disable-next-line: undefined-field
                    and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
            end, linters)

            if #linters > 0 then require("lint").try_lint(linters) end
        end

        lint()

        local timer = assert(vim.uv.new_timer())
        vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
            group = require("dotfyls.interop").group,
            callback = function(args)
                timer:start(100, 0, function()
                    timer:stop()

                    vim.schedule(function() lint(args.buf) end)
                end)
            end,
            desc = "Lint (nvim-lint)",
        })
    end,
}
