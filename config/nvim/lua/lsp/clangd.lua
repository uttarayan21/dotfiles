local lspconfig = require'lspconfig'
local lspstatus = require'lsp-status'
local coq = require'coq'

lspconfig.clangd.setup {
    capabilities = coq.lsp_ensure_capabilities(lspstatus.capabilities),
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
    single_file_support = true,
}
