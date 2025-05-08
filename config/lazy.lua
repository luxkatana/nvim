vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"
vim.lsp.inlay_hint.enable(true)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
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

vim.keymap.set("n", 'g[', vim.diagnostic.goto_next, {})
vim.keymap.set("n", 'g]', vim.diagnostic.goto_prev, {})



require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true, notify = true },
})
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true


-- Treesitter Plugin Setup
require('nvim-treesitter.configs').setup {
    ensure_installed = { "lua", "rust", "toml", "css" },
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    ident = { enable = true },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    }
}



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
    telescope_builtin.find_files(opts)

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

vim.keymap.set("", "<C-p>", list_appropriate_dir, {})


vim.keymap.set("", "<C-n>", function()
    vim.cmd.vnew()
    list_appropriate_dir()
end)
vim.keymap.set("", "<Leader>help", telescope_builtin.help_tags, {})
-- Assign control space to open hover doc
vim.keymap.set("", "<C-Space>", vim.lsp.buf.hover, { noremap = true })

local lspconfig = require 'lspconfig'
lspconfig.pyright.setup {
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off",
            }

        }

    }
}


lspconfig.cssls.setup {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

lspconfig.lua_ls.setup {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                version = 'LuaJIT'
            },
            workspace = {
                checkThirdParty = true,
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



vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>TmuxNavigateDown<cr>")
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>TmuxNavigateUp<cr>")
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>TmuxNavigateRight<cr>")

vim.keymap.set("n", "<Leader>goto", vim.lsp.buf.definition, { noremap = true })

vim.api.nvim_create_user_command("Format", function()
    vim.lsp.buf.format({ async = true })
end, {})

