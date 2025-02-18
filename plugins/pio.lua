return {
    "anurag3301/nvim-platformio.lua",
    config = function()
        require"platformio".setup {
            lsp = "clangd"
        }

    end,
    dependencies = {
        { "akinsho/nvim-toggleterm.lua" },
        { "nvim-telescope/telescope.nvim" },
        { "nvim-lua/plenary.nvim" }
        }
}
