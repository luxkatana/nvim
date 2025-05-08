return {
  'stevearc/oil.nvim',
  dependencies = { { "echasnovski/mini.icons"} },
  lazy = false,
  config = function()
      require"oil".setup{}
      vim.api.nvim_create_user_command("Ex",  "Oil", { desc = "Open parent directory" })
  end
}
