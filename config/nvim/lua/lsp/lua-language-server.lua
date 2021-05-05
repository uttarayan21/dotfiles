local lspconfig = require'lspconfig'
-- local lspstatus = require('lsp-status')

require'lspconfig'.sumneko_lua.setup{
    cmd = { "lua-language-server" },
    on_attach=function(client) require'completion'.on_attach(client) require'lsp-status'.on_attach(client) return end,
    -- on_attach=require'completion'.on_attach,
    filetypes = { "lua" },
    log_level = 2,
    root_dir = lspconfig.util.root_pattern(".git"),
    settings = {
      Lua = {
        telemetry = {
          enable = false
        }
      }
    }
}
