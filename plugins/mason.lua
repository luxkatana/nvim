return {
    {"williamboman/mason.nvim", config = true },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {{"williamboman/mason.nvim", config=true}},
        config = function()
            local lspconfig = require("mason-lspconfig")
            lspconfig.setup {
                ensure_installed = { "cssls", "lua_ls" }
            }
            lspconfig.setup_handlers {
                function(server_name)
                    require "lspconfig"[server_name].setup {}
                end
            }
        end
    },
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    --{ 'mrcjkb/rustaceanvim',     version = '^5', lazy = false },
    "tpope/vim-fugitive",
    "christoomey/vim-tmux-navigator",
    "nvim-tree/nvim-web-devicons"
}
