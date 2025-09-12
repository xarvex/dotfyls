return {
    "Saghen/blink.pairs",
    build = {
        vim.fn.executable("nix") == 1 and "nix run .#build-plugin --override-input nixpkgs nixpkgs"
            or "cargo build --release",
        function(plugin)
            local cargo_target_dir = vim.env.CARGO_TARGET_DIR
            if cargo_target_dir ~= nil then
                local plugin_lib_dir = vim.fs.joinpath(plugin.dir, "target", "release")
                vim.fn.mkdir(plugin_lib_dir, "p")
                vim.fn.filecopy(
                    vim.fs.joinpath(cargo_target_dir, "release", "libblink_pairs.so"),
                    vim.fs.joinpath(plugin_lib_dir, "libblink_pairs.so")
                )
            end
        end,
    },
    event = { "BufNewFile", "BufReadPost" },
    ---@module "blink.pairs"
    ---@type blink.pairs.Config
    opts = { highlights = { enabled = false } },
}
