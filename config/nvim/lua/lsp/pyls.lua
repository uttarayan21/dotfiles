local lspconfig = require'lspconfig'

lspconfig.pyls.setup{
    coq.lsp_ensure_capabilities{
        cmd = { "pyls" },
        filetypes = { "python" },
    }
}
