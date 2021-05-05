-- Built in lsp
local lspconfig = require'lspconfig'
-- local lspstatus = require('lsp-status')
-- lspstatus.register_progress()

lspconfig.rust_analyzer.setup{
    on_attach=function(client) require'completion'.on_attach(client) require'lsp-status'.on_attach(client) return end,
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_dir = lspconfig.util.root_pattern("Cargo.toml"),
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy";
            },
            cargo = {
                allFeatures = true;
            }
        }
    }
}

