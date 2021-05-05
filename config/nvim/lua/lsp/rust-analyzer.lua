-- Built in lsp
local lspconfig = require'lspconfig'

lspconfig.rust_analyzer.setup{
    on_attach=require'completion'.on_attach;
    cmd = { "rust-analyzer" };
    filetypes = { "rust" };
    root_dir = lspconfig.util.root_pattern("Cargo.toml");
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

