vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
vim.opt.cmdheight = 0



vim.cmd("hi LineNrAbove guifg=red ctermfg=red")
vim.cmd("hi LineNrBelow guifg=red ctermfg=red")


require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true, notify=true},
})
vim.opt.tabstop = 4          -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 4       -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true     -- Convert tabs to spaces
vim.opt.smartindent = true   -- Automatically insert one extra level of indentation in some cases
vim.opt.autoindent = true    -- Copy indent from current line when starting a new line
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {"cssls"}

}


-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  mapping = {
    --[[['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),]]
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    --['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-k>'] = cmp.mapping.scroll_docs(-4),
    ['<C-j>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:

  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

-- Treesitter Plugin Setup 
require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "rust", "toml", "css"},
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}


vim.cmd("colorscheme onedark")
vim.wo.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = "number"

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup("autoupdate"),
    callback = function()
        if require("lazy.status").has_updates then
            require("lazy").update({ show = false, })
        end
    end,
})

local telescope_builtin = require("telescope.builtin")
local function list_appropriate_dir()
    local opts = {
        cwd = require("telescope.utils").buffer_dir()
    }
    if vim.loop.fs_stat(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h").."/.git") == nil then
    telescope_builtin.find_files(opts)

else
    telescope_builtin.git_files(opts)
end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end
vim.keymap.set("", "<C-p>", list_appropriate_dir, {silent=false})

vim.keymap.set("", "<C-Space>", vim.lsp.buf.hover, {noremap=true, silent=true})

vim.keymap.set("", "<C-n>", function()
    vim.cmd.vnew()
    list_appropriate_dir()
end)
vim.keymap.set("", "<Leader>h", telescope_builtin.help_tags, {})

--vim.keymap.set("", "<C-k>", vim.diagnostic.goto_prev, {noremap=true})
local lspconfig = require'lspconfig'
lspconfig.cssls.setup {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
}



lspconfig.ruff.setup({})

lspconfig.pyright.setup({
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "off",
			}

		}

	}


})
lspconfig.emmet_language_server.setup{}
lspconfig.lua_ls.setup {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT'
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
}
vim.wo.cursorline = true

require("code_runner").setup {
	filetype = {
		python = "python3 "

	}

}

require("livepreview.config").set {
    port = 8000,

}
vim.g["terminal_current_buffer"] = 0

vim.keymap.set({"n", "t"}, "<C-t>", function()
    local terminal_buffer = vim.g["terminal_current_buffer"]
    if vim.api.nvim_buf_is_valid(terminal_buffer) == false then
        vim.g["terminal_current_buffer"] = 0
    end

    local current_buffer = vim.api.nvim_get_current_buf()
    if current_buffer == 1 and terminal_buffer == 0 then
    vim.api.nvim_exec2("below term", {})
    vim.g["terminal_current_buffer"] = vim.api.nvim_get_current_buf()

    vim.cmd.resize(5)
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.api.nvim_feedkeys("i", "n", false)
elseif current_buffer == terminal_buffer then
    vim.api.nvim_win_close(vim.api.nvim_get_current_win(), false)
else
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.api.nvim_exec2("below new", {})
    vim.cmd.resize(5)
    vim.api.nvim_set_current_buf(terminal_buffer)
end
end, {})


require('mini.icons').setup{}
require"lualine".setup {
	theme = "dracula"
}

vim.keymap.set({"n", "t"}, "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
vim.keymap.set({"n", "t"}, "<C-j>", "<cmd>TmuxNavigateDown<cr>")
vim.keymap.set({"n", "t"}, "<C-k>", "<cmd>TmuxNavigateUp<cr>")
vim.keymap.set({"n", "t"}, "<C-l>", "<cmd>TmuxNavigateRight<cr>")

-- The setup config table shows all available config options with their default values:
require("presence").setup({
    -- General options
    auto_update         = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
    neovim_image_text   = "Neovim", -- Text displayed when hovered over the Neovim image
    main_image          = "file",                   -- Main image display (either "neovim" or "file")
    client_id           = "793271441293967371",       -- Use your own Discord application client id (not recommended)
    log_level = nil,
    buttons             = {{label = "fun website", url="https://chinesespypigeon.lol"}},                       -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
    show_time           = true,                       -- Show the timer

    -- Rich Presence text options
    editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
})
