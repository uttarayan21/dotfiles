-- local vim = vim
require('plugins')
require('keymaps')

-- Need to replace this once lua api has vim modes
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
    autocmd BufWritePost keymaps.lua PackerCompile
    autocmd BufWritePost plugins.lua PackerCompile
  augroup end
]], false)

vim.api.nvim_exec([[
augroup AutoSaveGroup
    autocmd!
    autocmd BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
    autocmd BufWinEnter ?* silent! loadview
augroup end
]], false)

vim.o.timeoutlen = 700
vim.o.guifont='Hasklug Nerd Font Mono,Hack Nerd Font,NotoEmoji Nerd Font'

vim.o.undodir=vim.fn.stdpath('cache')..'/undodir'
vim.o.undofile = true

vim.o.showmode = false
vim.o.showtabline = 2
vim.o.autoindent = true

vim.o.tabstop=4
vim.o.softtabstop=4

vim.o.shiftwidth=4
vim.bo.shiftwidth=4

vim.o.expandtab = true
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.termguicolors = true
-- No clue why window scoped
vim.wo.signcolumn='yes'

-- vim.o.modifiable = true
-- vim.bo.modifiable = true
vim.g.dashboard_default_executive = 'fzf'
vim.g.python_highlight_all = 1

vim.g.test = {
    default = {
	default = { 
	    complete_items = { 'lsp', 'snippet' },
	    mode = 'file',
	},
	comment = {},
	string = { complete_items = { 'path' } },
    },
    rust = { { complete_items = {'ts'} } },
}
