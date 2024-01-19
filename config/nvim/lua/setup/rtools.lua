-- Update this path
-- local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.7.0'
-- local codelldb_path = extension_path .. 'adapter/codelldb'
-- local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
local codelldb_path = '/Users/fs0c131y/.vscode-oss/extensions/vadimcn.vscode-lldb-1.8.1-universal/adapter/codelldb'
local liblldb_path = '/Users/fs0c131y/.vscode-oss/extensions/vadimcn.vscode-lldb-1.8.1-universal/lldb/lib/liblldb.dylib'
local lspstatus = require('lsp-status')
-- local lsp_signature = require('lsp_signature')


-- vim.cmd([[autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require('rust-tools.inlay_hints').set_inlay_hints()]])
-- require('rust-tools').setup(opts)
local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
    "n",
    "<leader>a",
    function()
        vim.cmd.RustLsp('codeAction')
    end,
    { silent = true, buffer = bufnr }
)
vim.keymap.set(
    "n",
    "<leader>rr",
    function()
        vim.cmd.RustLsp('runnables')
    end,
    { silent = true, buffer = bufnr }
)
vim.keymap.set(
    "n",
    "<leader>rd",
    function()
        vim.cmd.RustLsp('debuggables')
    end,
    { silent = true, buffer = bufnr }
)
vim.keymap.set(
    "n",
    "ssr",
    function()
        vim.cmd.RustLsp('ssr')
    end,
    { buffer = bufnr }
)

vim.g.rustaceanvim = {
    -- Plugin configuration
    -- tools = {},
    -- LSP configuration
    server = {
        on_attach = function(client, bufnr)
            -- you can also put keymaps in here
            lspstatus.on_attach(client, bufnr)
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(bufnr, true)
            end
        end,
        --     settings = {
        --       -- rust-analyzer language server configuration
        --       ["rust-analyzer"] = {},
        --     },
        --   },
        --   -- DAP configuration
        --   dap = {},
    },
}
