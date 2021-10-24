local lspconfig = require'lspconfig'
local lspstatus = require'lsp-status'
local coq = require'coq'

lspconfig.rust_analyzer.setup{
    on_attach=function(client) lspstatus.on_attach(client)  return end,
    capabilities = coq.lsp_ensure_capabilities(lspstatus.capabilities),
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_dir = lspconfig.util.root_pattern("Cargo.toml"),
    settings = {
        ["rust-analyzer"] = {
            lruCapacity = 64,
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
    },
}

