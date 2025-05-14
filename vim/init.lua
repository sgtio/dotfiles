local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Auto bootstrapping of lazy.nvim disabled. Don't download automatically.
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

plugins = {
    {"arcticicestudio/nord-vim", lazy = true},
    {"NLKNguyen/papercolor-theme", lazy = false},
    {'itchyny/lightline.vim', lazy = false},
    'mileszs/ack.vim',
    {"nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed =
                    { "bash", "c", "lua", "markdown", "python", "rust", "vim", "vimdoc" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
              })
        end
    },
    {"aserowy/tmux.nvim",
        config = function() return require("tmux").setup({
            copy_sync = {
                redirect_to_clipboard = true,
            }
        }) end
    },
    {"tpope/vim-fugitive"},
    {"lewis6991/gitsigns.nvim",
        config = function() return require('gitsigns').setup() end
    },
    {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
    'rust-lang/rust.vim'
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^6', -- Recommended
        lazy = false, -- This plugin is already lazy
    }
}

require("lazy").setup(plugins)

-- Now that the plugins are loaded, source our vimrc file
local vimrc = vim.fn.stdpath("config") .. "/vimrc"
vim.cmd.source(vimrc)
