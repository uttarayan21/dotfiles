local lspstatus = require('lsp-status')
local bufnr = vim.api.nvim_get_current_buf()
-- vim.keymap.set(
--     "n",
--     "<leader>a",
--     function()
--         vim.cmd.RustLsp('codeAction')
--     end,
--     { silent = true, buffer = bufnr }
-- )
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
        capabilities = require'lsp-zero'.get_capabilities(),
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
    },
    dap = {
        autoload_configurations = false
    },
}
