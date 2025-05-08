return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require"lualine".setup {
            options = {
            theme = "dracula",
        },
            sections = {
                lualine_x = {"filetype"},
                lualine_y = {},
                lualine_z = {}

            }

        }
    end
}
