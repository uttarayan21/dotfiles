local lspconfig = require 'lspconfig'
local lspstatus = require 'lsp-status'

local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local capabilities = cmp_nvim_lsp.default_capabilities()
require("mason-lspconfig").setup_handlers {
    function(server_name) -- default handler (optional)
        lspconfig[server_name].setup {
            on_attach = function(client, bufnr)
                lspstatus.on_attach(client, bufnr)
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(bufnr, true)
                end
            end,
            capabilities = capabilities,
        }
    end,
    ["rust_analyzer"] = function()
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
    ["ast_grep"] = function()
        lspconfig.ast_grep.setup {
            cmd = { "sg", "lsp" },
            filetypes = { "c", "cpp", "rust", "typescript" },
            root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
            single_file_support = true,
        }
    end
}
