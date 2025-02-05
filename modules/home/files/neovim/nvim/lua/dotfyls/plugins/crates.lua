---@module "lazy"
---@type LazySpec
return {
    "saecki/crates.nvim",
    cmd = "Crates",
    event = { "BufNewFile Cargo.toml", "BufReadPost Cargo.toml" },
    opts = {
        lsp = {
            enabled = true,
            actions = true,
            completion = true,
            hover = true,
        },
    },
}
