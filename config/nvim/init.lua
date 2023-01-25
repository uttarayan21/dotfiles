-- Need to replace this once lua api has vim modes
-- vim.api.nvim_exec([[
--   augroup Packer
--     autocmd!
--     autocmd BufWritePost init.lua PackerCompile
--     autocmd BufWritePost keymaps.lua PackerCompile
--     autocmd BufWritePost plugins.lua PackerCompile
--   augroup end
-- ]], false)

vim.api.nvim_exec([[
augroup AutoSaveGroup
    autocmd!
    autocmd BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
    autocmd BufWinEnter ?* silent! loadview
augroup end
au BufNewFile,BufRead,BufReadPost *.html.tera set syntax=HTML
]], false)

vim.api.nvim_exec([[
autocmd BufNewFile,BufRead *.sol set ft=solidity
]], false)

vim.o.number = true
vim.o.relativenumber = true
vim.o.timeoutlen = 700
vim.o.guifont = 'Hasklug Nerd Font Mono,Hack Nerd Font,NotoEmoji Nerd Font:h11'

vim.o.undodir = vim.fn.stdpath('cache') .. '/undodir'
vim.o.undofile = true

vim.o.autoread = true
vim.o.foldmethod = 'indent'

vim.o.showmode = false
vim.o.showtabline = 0
vim.o.autoindent = true

vim.o.tabstop = 4
vim.o.softtabstop = 4

vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4

vim.o.expandtab = true
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.termguicolors = true
-- No clue why window scoped
vim.wo.signcolumn = 'yes'
vim.opt.list = true
-- vim.o.colorcolumn = '+1'
-- vim.o.textwidth = 120

-- vim.opt.listchars:append("eol:↴")
-- vim.diagnostic.config({
--     virtual_text = false,
-- })


vim.o.wrap = false

-- vim.o.modifiable = true
-- vim.bo.modifiable = true
vim.g.dashboard_default_executive = 'fzf'
vim.g.python_highlight_all = 1


-- vim.g.test = {
--     default = {
--         default = {
--             complete_items = { 'lsp', 'snippet' },
--             mode = 'file',
--         },
--         comment = {},
--         string = { complete_items = { 'path' } },
--     },
--     rust = { { complete_items = { 'ts' } } },
-- }


vim.o.completeopt = 'menuone,noselect'

vim.g.coq_settings = {
    auto_start = 'shut-up',
    weights = {
        prefix_matches = 4
    },
    clients = {
        lsp = {
            weight_adjust = 2
        },
        -- buffers = {
        --     -- weight_adjust = -0.5
        -- },
        -- snippets = {
        --     -- weight_adjust = -0.1
        -- }
    }
}
-- vim.g.rooter_manual_only = 1
vim.g.copilot_node_command = "~/.local/share/nvm/v16.18.1/bin/node"

require('keymaps')
require('plugins')

require 'nvim-treesitter.configs'.setup {
    -- ensure_installed = "all",
    ensure_installed = { "c", "rust", "toml", "lua", "json", "python", "cmake", "make", "typescript", "bash", "cpp",
        "comment", "css", "fish", "http", "html", "vim", "yaml" },
    highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = false,
    },
}

vim.notify = require 'notify'
