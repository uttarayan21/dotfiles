local lspconfig = require'lspconfig'

lspconfig.pyls.setup{
    cmd = { "pyls" },
    filetypes = { "python" },
}
