require('plugins')
require('keymaps')

-- Need to replace this once lua api has vim modes
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]], false)

vim.o.timeoutlen = 700
vim.o.guifont='FiraCode Nerd Font Mono'

vim.o.undodir=vim.fn.stdpath('cache')..'undodir'
vim.o.undofile = true

vim.o.showmode = false
vim.o.showtabline = 2
vim.o.autoindent = true
vim.o.tabstop=4
vim.o.shiftwidth=4
vim.o.expandtab = true
vim.o.signcolumn="yes"
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.termguicolors = true

-- nnoremap <silent> <F2> :set number! relativenumber! <CR>
-- nnoremap <silent> <F3> :IndentLinesToggle <CR>

-- inoremap <C-j> <ESC> 
