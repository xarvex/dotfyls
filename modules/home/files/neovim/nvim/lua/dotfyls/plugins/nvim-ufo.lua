return {
    {
        "kevinhwang91/nvim-ufo",
        event = { "BufNewFile", "BufReadPost" },
        keys = {
            { "zR", function() require("ufo").openAllFolds() end },
            { "zM", function() require("ufo").closeAllFolds() end },
        },
        opts = {
            provider_selector = function() return { "treesitter", "indent" } end,
            fold_virt_text_handler = function(virtual_text, lnum, end_lnum, width, truncate)
                local new_virtual_text = {}

                local suffix = (" 󰁂 %d "):format(end_lnum - lnum)
                local suffix_width = vim.fn.strdisplaywidth(suffix)
                local target_width = width - suffix_width

                local aggregated_width = 0
                for i = 1, #virtual_text do
                    local chunk = virtual_text[i]
                    local chunk_text = chunk[1]
                    local chunk_width = vim.fn.strdisplaywidth(chunk_text)

                    if target_width > aggregated_width + chunk_width then
                        new_virtual_text[#new_virtual_text + 1] = chunk
                    else
                        chunk_text = truncate(chunk_text, target_width - aggregated_width)

                        new_virtual_text[#new_virtual_text + 1] = { chunk_text, chunk[2] }

                        chunk_width = vim.fn.strdisplaywidth(chunk_text)
                        if aggregated_width + chunk_width < target_width then
                            suffix = suffix .. (" "):rep(target_width - aggregated_width - chunk_width)
                        end

                        break
                    end

                    aggregated_width = aggregated_width + chunk_width
                end

                new_virtual_text[#new_virtual_text + 1] = { suffix, "MoreMsg" }

                return new_virtual_text
            end,
        },
    },
    { "kevinhwang91/promise-async", lazy = true },
}
