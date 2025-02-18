return {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    {"olimorris/onedarkpro.nvim", priority=1000},
    {'mrcjkb/rustaceanvim',version = '^5', lazy = false},
    { "CRAG666/code_runner.nvim", config = true },
    "tpope/vim-fugitive",
    "brianhuster/live-preview.nvim",
    'ibhagwan/fzf-lua',
    'echasnovski/mini.pick',
    "andweeb/presence.nvim",
    {
        "christoomey/vim-tmux-navigator",
--[[        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        }
    },
    ]]
}
    ,
    { 'echasnovski/mini.nvim', version = false },
    "nvim-tree/nvim-web-devicons"
}

