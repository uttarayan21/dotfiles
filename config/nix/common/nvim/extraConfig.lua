vim.g.rustaceanvim = {
    server = {
        on_attach = function(client, bufnr)
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(bufnr, true)
            end
        end,
    },
    dap = {
        autoload_configurations = false
    },
}

require("copilot").setup({
    suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
            accept = "<C-l>",
        }
    },
    panel = { enabled = true },
})

require 'fidget'.setup()

local cmp = require 'cmp'
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline {
        ['<C-n>'] = cmp.config.disable,
        ['<C-p>'] = cmp.config.disable,
    },
    sources = {
        { name = 'buffer' }
    }
})
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline {
        ['<C-n>'] = cmp.config.disable,
        ['<C-p>'] = cmp.config.disable,
    },
    -- mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
        { name = 'buffer' },
    })
})

require('telescope').setup {
    defaults = {
        initial_mode = 'insert',
    },
    extensions = {
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        }
    }
}

require("telescope").load_extension("ui-select")
require('telescope').load_extension("fzf")
require('telescope').load_extension("file_browser")
