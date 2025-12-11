local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
-- Auto bootstrapping of lazy.nvim disabled. Don't download automatically.
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

plugins = {
    {'arcticicestudio/nord-vim', lazy = true},
    {'NLKNguyen/papercolor-theme', lazy = false},
    {'itchyny/lightline.vim', lazy = false},
    {'mileszs/ack.vim'},
    {'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function ()
            local configs = require('nvim-treesitter.configs')

            configs.setup({
                ensure_installed =
                    { 'bash', 'c', 'lua', 'markdown', 'python', 'rust', 'vim', 'vimdoc' },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
              })
        end
    },
    {'aserowy/tmux.nvim',
        config = function() return require('tmux').setup({
            copy_sync = {
                redirect_to_clipboard = true,
            }
        }) end
    },
    {'tpope/vim-fugitive'},
    {'lewis6991/gitsigns.nvim',
        config = function() return require('gitsigns').setup() end
    },
    {'nvim-telescope/telescope.nvim', branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {'nvim-telescope/telescope-ui-select.nvim'},
    {'rust-lang/rust.vim'},
    {'mrcjkb/rustaceanvim',
        version = '^6', -- Recommended
        lazy = false, -- This plugin is already lazy
    },
    {'github/copilot.vim',
        branch = 'release',
    },
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        enabled = true,
        dependencies = {
            { 'nvim-lua/plenary.nvim', branch = 'master' },
        },
        build = 'make tiktoken',
        opts = {
            model = 'claude-sonnet-4',   -- AI model to use
            model = 'gpt-4.1',   -- AI model to use
            temperature = 0.1,           -- Lower = focused, higher = creative
            window = {
                layout = 'float',
                width = 80, -- Fixed width in columns
                height = 20, -- Fixed height in rows
                border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
                title = '🤖 AI Assistant',
                zindex = 1, -- Ensure window stays on top, but let Telescope do its thing
            },
            headers = {
                user = '👤 You',
                assistant = '🤖 Copilot',
                tool = '🔧 Tool',
            },
            auto_insert_mode = true,     -- Enter insert mode when opening
        }
    },
    {'neovim/nvim-lspconfig'}
}

require('lazy').setup(plugins)

-- Now that the plugins are loaded, source our vimrc file
local vimrc = vim.fn.stdpath('config') .. '/vimrc'
vim.cmd.source(vimrc)

vim.lsp.enable({
    'pyright',
    'clangd',
    'rust-analyzer',
})

vim.g.copilot_no_tab_map = true -- Enable when using CopilotChat
vim.keymap.set('i', '<S-Tab>', "copilot#Accept('\\<S-Tab>')", { expr = true, replace_keycodes = false })

require('telescope').setup {
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown {
            }
        }
    }
}

-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('ui-select')
