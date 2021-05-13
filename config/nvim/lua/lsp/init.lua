-- local lspstatus = require('lsp-status')
-- lspstatus.register_progress()

require("lsp.rust-analyzer")
require("lsp.lua-language-server")
require("lsp.pyls")

-- Set completeopt to have a better completion experience
vim.o.completeopt= "menuone,noinsert,noselect"

-- vim.api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
-- vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
-- vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
--
vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
