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
au BufNewFile,BufRead,BufReadPost *.html.tera set syntax=HTML
]], false)

vim.o.number = true 
vim.o.relativenumber = true
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


-- Temp

vim.o.completeopt = 'menuone,noselect'

-- -- luasnip setup
-- local luasnip = require 'luasnip'

-- -- nvim-cmp setup
-- local cmp = require 'cmp'
-- cmp.setup {
--   snippet = {
--     expand = function(args)
--       require('luasnip').lsp_expand(args.body)
--     end,
--   },
--   mapping = {
--     ['<C-p>'] = cmp.mapping.select_prev_item(),
--     ['<C-n>'] = cmp.mapping.select_next_item(),
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.close(),
--     ['<CR>'] = cmp.mapping.confirm {
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     },
--     ['<Tab>'] = function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       elseif luasnip.expand_or_jumpable() then
--         luasnip.expand_or_jump()
--       else
--         fallback()
--       end
--     end,
--     ['<S-Tab>'] = function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       elseif luasnip.jumpable(-1) then
--         luasnip.jump(-1)
--       else
--         fallback()
--       end
--     end,
--   },
--   sources = {
--     { name = 'nvim_lsp' },
--     { name = 'luasnip' },
--   },
-- }
