return {
    "vimlab/split-term.vim",
    config = function()
        vim.cmd("set splitbelow")
        vim.api.nvim_set_keymap('n', "<C-T>", ":10Term<CR>", {})
    end

}
