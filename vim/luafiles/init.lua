local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Auto bootstrapping of lazy.nvim disabled. Don't download automatically.
--if not vim.loop.fs_stat(lazypath) then
--  vim.fn.system({
--    "git",
--    "clone",
--    "--filter=blob:none",
--    "https://github.com/folke/lazy.nvim.git",
--    "--branch=stable", -- latest stable release
--    lazypath,
--  })
--end
vim.opt.rtp:prepend(lazypath)

plugins = {
    {"arcticicestudio/nord-vim", lazy = true},
    {"NLKNguyen/papercolor-theme", lazy = false},
    'itchyny/lightline.vim',
    'mileszs/ack.vim',
    {"nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "c", "lua", "python", "rust", "vim", "vimdoc" },
                sync_install = false,
                highlight = { enable = false },
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
}

require("lazy").setup(plugins)

-- Now that the plugins are loaded, source our vimrc file
local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)
