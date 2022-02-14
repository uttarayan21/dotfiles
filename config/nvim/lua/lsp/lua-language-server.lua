local lspconfig = require'lspconfig'
local lspstatus = require('lsp-status')
-- local coq = require'coq'

lspconfig.sumneko_lua.setup{
    cmd = { "lua-language-server" },
    on_attach=function(client) lspstatus.on_attach(client)  return end,
    -- capabilities = coq.lsp_ensure_capabilities(lspstatus.capabilities),
    filetypes = { "lua" },
    log_level = 2,
    settings = {
      Lua = {
        diagnostics = {
            globals = {'vim'},
        },
        telemetry = {
            enable = false,
        }
      }
    }
}
-- lspconfig.sumenko_lua.setup(coq.lsp_ensure_capabilities())
-- require'lspconfig'.sumneko_lua.setup{coq.lsp_ensure_capabilities()}
