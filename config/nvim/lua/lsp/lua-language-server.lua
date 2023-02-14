local lspconfig = require 'lspconfig'
local lspstatus = require('lsp-status')
local coq = require 'coq'

lspconfig.lua_ls.setup {
    cmd = { "lua-language-server" },
    on_attach = function(client) lspstatus.on_attach(client) end,
    capabilities = coq.lsp_ensure_capabilities(lspstatus.capabilities),
    filetypes = { "lua" },
    log_level = 2,
    settings = {
      Lua = {
        diagnostics = {
            globals = { 'vim' },
        },
        telemetry = {
            enable = false,
        },
        formatting = {
            end_of_line = 'lf',
        },
      }
    }
}
