local lspconfig = require'lspconfig'


lspconfig.rust_analyzer.setup{
    on_attach=function(client) require'lsp-status'.on_attach(client)  return end,
    capabilities = require'lsp-status'.capabilities,
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_dir = lspconfig.util.root_pattern("Cargo.toml"),
    settings = {
        ["rust-analyzer"] = {
           assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            procMacro = {
                enable = true,
            },
            checkOnSave = {
                command = "clippy",
                allTargets = true,
            },
            cargo = {
                loadOutDirsFromCheck = true,
                allFeatures = true,
            }
        }
    }
}

lspconfig.rust_analyzer.setup{
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}
