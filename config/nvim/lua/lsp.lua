local lspconfig = require 'lspconfig'
local lspstatus = require 'lsp-status'

local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local capabilities = cmp_nvim_lsp.default_capabilities()
require("mason-lspconfig").setup_handlers {
    function(server_name) -- default handler (optional)
        lspconfig[server_name].setup {
            on_attach = lspstatus.on_attach,
            capabilities = capabilities,
        }
    end,
    ["rust_analyzer"] = function()
        -- require 'lazy'.load('rust-tools');
        vim.cmd([[autocmd BufEnter *.rs lua require("setup.rtools")]])
    end,
    ["clangd"] = function()
        lspconfig.clangd.setup {
            capabilities = capabilities,
            cmd = { "clangd" },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
            single_file_support = true,
        }
    end,
}