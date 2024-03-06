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
require("telescope").load_extension("dap")
require('telescope').load_extension("fzf")
require('telescope').load_extension("file_browser")

vim.g.rustaceanvim = {
    tools = {
        enable_clippy = false,
    },
    server = {
        capabilities = require 'lsp-zero'.get_capabilities(),
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


-- =======================================================================
-- nvim-cmp
-- =======================================================================

local cmp = require("cmp")
cmp.setup({
    view = {
        entries = { name = 'custom', selection_order = 'near_cursor' }
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sources = cmp.config.sources({
        { name = "copilot", },
        { name = 'buffer' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'treesitter' },
        { name = 'path' },
        { name = 'git' },
        { name = 'tmux' }
    }),
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm(),
        ['<C-y>'] = cmp.mapping.complete(),
        -- ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-n>'] = cmp.config.next,
        ['<C-p>'] = cmp.config.prev,
    })
})

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
require('crates').setup()
require('outline').setup()
require("noice").setup({
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
    },
})

require 'FTerm'.setup({
    border     = 'double',
    dimensions = {
        height = 0.9,
        width = 0.9,
    },
    cmd        = "fish",
    blend      = 10,
})
