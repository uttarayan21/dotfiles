local lspconfig = require'lspconfig'
local lspstatus = require'lsp-status'
-- local coq = require'coq'

lspconfig.solang.setup{
    on_attach=function(client) lspstatus.on_attach(client) end,
    -- capabilities = coq.lsp_ensure_capabilities(lspstatus.capabilities),
}
