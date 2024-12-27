return {
    "Saecki/crates.nvim",
    cmd = "Crates",
    event = { "BufNewFile Cargo.toml", "BufReadPost Cargo.toml" },
    opts = {
        completion = {
            cmp = { enabled = true },
        },
        lsp = {
            enabled = true,
            actions = true,
            completion = true,
            hover = true,
        },
    },
}
