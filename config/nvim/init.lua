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
au BufNewFile,BufRead,BufReadPost *.html.tera set syntax=HTML
]], false)

vim.o.number = true
vim.o.relativenumber = true
vim.o.timeoutlen = 700
vim.o.guifont='Hasklug Nerd Font Mono,Hack Nerd Font,NotoEmoji Nerd Font:h11'

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


vim.o.completeopt = 'menuone,noselect'

vim.g.coq_settings = {
    auto_start = 'shut-up'
}

require('plugins')
require('keymaps')

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
  },
}

