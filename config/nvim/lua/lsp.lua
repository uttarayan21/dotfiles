local lspconfig = require 'lspconfig'
local lspstatus = require 'lsp-status'
local lsp_zero = require'lsp-zero'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'

local capabilities = cmp_nvim_lsp.default_capabilities()

lsp_zero.extend_lspconfig()
lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(bufnr, true)
    end
end)

local lua_opts = lsp_zero.nvim_lua_ls()
lspconfig.lua_ls.setup(lua_opts)
lspconfig.nil_ls.setup({
    settings = {
        ['nil'] = {
          formatting = {
            command = { "nixfmt" },
          },
        },
      },
})
lspconfig.clangd.setup({})
