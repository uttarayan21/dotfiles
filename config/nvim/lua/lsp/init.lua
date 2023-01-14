-- local lspstatus = require('lsp-status')
-- lspstatus.register_progress()

require("lsp.lua-language-server")
require("lsp.clangd")
-- require("lsp.tsserver")
-- require("lsp.pyright")
-- require("lsp.rust-analyzer")
-- require 'lspconfig'.clangd.setup {}
require 'lspconfig'.tsserver.setup {}
require 'lspconfig'.pyright.setup {}
require 'lspconfig'.sqls.setup {}

-- Set completeopt to have a better completion experience
-- vim.o.completeopt= "menuone,noinsert,noselect"
vim.o.completeopt = "menuone,noselect"

-- vim.api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
-- vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
-- vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
--
vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

local lspconfig = require 'lspconfig'
local lspstatus = require 'lsp-status'
local coq = require 'coq'

require('mason-lspconfig').setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            on_attach = lspstatus.on_attach,
            capabilities = coq.lsp_ensure_capabilities(lspstatus.capabilities),
        })
    end,
})
