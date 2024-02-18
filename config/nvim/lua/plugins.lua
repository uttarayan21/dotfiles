local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
-- require("lazy").setup(plugins, opts)
-- if fn.empty(fn.glob(install_path)) > 0 then
--     fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
--     execute 'packadd packer.nvim'
-- end

-- local use = require('packer').use

return require('lazy').setup({
    {
        "ellisonleao/glow.nvim",
        config = true,
        cmd =
        "Glow"
    },
    'samoshkin/vim-mergetool',
    {
        cmd = { "Format", "FormatWrite" },
        'mhartington/formatter.nvim'

    },

    { 'tpope/vim-commentary',          lazy = false },
    {
        'tpope/vim-fugitive',
        cmd = { "Git", "Gdiffsplit", "Gvdiffsplit", "Gedit", "Gread", "Gwrite",
            "Ggrep", "Gbrowse", "GMove", "GDelete" }
    },
    { 'tpope/vim-repeat',              lazy = false },
    { 'tpope/vim-speeddating',         lazy = false },
    { 'tpope/vim-surround',            lazy = false },
    { 'tpope/vim-vinegar',             lazy = false },
    { 'tpope/vim-abolish',             lazy = false },
    { 'yuttie/comfortable-motion.vim', event = "BufEnter" },
    { 'rest-nvim/rest.nvim',           event = "BufEnter" },
    { 'echasnovski/mini.nvim',         version = '*' },
    {
        'folke/todo-comments.nvim',
        event = "BufEnter",
        config = function() require('todo-comments').setup() end,
    },
    -- {
    --     'github/copilot.vim',
    --     event = "LspAttach",
    --     cmd = "Copilot",
    -- },
    -- 'ggandor/leap.nvim',
    {
        'sainnhe/sonokai',
        lazy = false,
        config = function()
            require('colorscheme')
        end
    },
    {
        {
            "nvim-neorg/neorg",
            cmd = "Neorg",
            ft = "norg",
            build = ":Neorg sync-parsers",
            opts = {
                load = {
                    ["core.defaults"] = {},  -- Loads default behaviour
                    ["core.concealer"] = {}, -- Adds pretty icons to your documents
                    ["core.completion"] = {
                        config = {
                            engine = "nvim-cmp",
                        }
                    },
                    ["core.dirman"] = { -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/Documents/norg",
                            },
                            default_workspace = "general",
                            index = "index.norg"
                        },
                    },
                },
            },
            dependencies = { "nvim-lua/plenary.nvim" },
        }
    },
    { 'folke/which-key.nvim', config = function() require("which-key").setup() end, event = "BufEnter" },
    {
        'nvim-telescope/telescope.nvim',
        cmd = "Telescope",
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim',
            'nvim-telescope/telescope-fzf-native.nvim' }
    },
    -- {
    --     'akinsho/git-conflict.nvim',
    --     version = "*",
    --     config = function()
    --         require('git-conflict').setup()
    --     end
    -- },
    -- {
    --     'williamboman/mason.nvim',
    --     cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
    --     config = function()
    --         require("mason").setup({
    --             ui = {
    --                 icons = {
    --                     package_installed = "✓",
    --                     package_pending = "➜",
    --                     package_uninstalled = "✗"
    --                 }
    --             }
    --         })
    --     end,
    -- },
    -- {
    --     "williamboman/mason-lspconfig.nvim",
    --     config = function()
    --         require("mason-lspconfig").setup({
    --             automatic_installation = true,
    --         })
    --         -- if not vim.fn.filereadable("/etc/nix/nix.conf") then (
    --         --     require("mason-lspconfig").setup({
    --         --         ensure_installed = { "lua_ls" },
    --         --         automatic_installation = true,
    --         --     })
    --         -- )
    --         -- end
    --     end,
    --     lazy = false,
    -- },
    {
        'NTBBloodbath/galaxyline.nvim',
        branch = 'main',
        lazy = false,
        config = function() require('statusline') end,
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        build = 'make',
        config = function()
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
            require('telescope').load_extension('fzf')
        end,
    },
    { 'lambdalisue/suda.vim', lazy = false },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            require("telescope").load_extension("ui-select")
        end
    },
    { 'norcalli/nvim-colorizer.lua', config = function() require 'colorizer'.setup() end },
    {
        'IndianBoy42/tree-sitter-just',
        config = function()
            require 'tree-sitter-just'.setup({})
        end,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = "just"
    },
    {
        'LhKipp/nvim-nu',
        config = function()
            require 'nu'.setup({
                use_lsp_features = false,
            })
        end,
        ft = "nu"
    },
    {
        'folke/trouble.nvim',
        cmd = {
            "Trouble",
            "TroubleClose",
            "TroubleToggle",
            "TroubleRefresh",
        },
        config = function()
            -- local actions = require("telescope.actions")
            require("trouble").setup()
            local trouble = require("trouble.providers.telescope")
            local telescope = require("telescope")
            telescope.setup {
                defaults = {
                    mappings = {
                        i = { ["<c-t>"] = trouble.open_with_trouble },
                        n = { ["<c-t>"] = trouble.open_with_trouble },
                    },
                },
            }
        end,
    },
    {
        'neovim/nvim-lspconfig',
        cmd = "LspStart",
        ft = { "rust", "toml", "lua", "c", "cpp", "markdown", "sql", "python", "go" },
        config = function()
            require("lsp")
        end
    },
    { 'hrsh7th/cmp-nvim-lsp',        lazy = false },
    { 'hrsh7th/cmp-buffer',          lazy = false },
    { 'hrsh7th/cmp-path',            lazy = false },
    { 'hrsh7th/cmp-cmdline',         lazy = false },
    { 'L3MON4D3/LuaSnip' },
    { 'saadparwaiz1/cmp_luasnip' },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end
    },
    {
        "petertriho/cmp-git",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function() require "cmp_git".setup() end,
    },
    {
        'hrsh7th/nvim-cmp',
        lazy = false,
        config = function()
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
                    { name = 'path' },
                    { name = 'git' },
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
        end
    },
    {
        'nvim-lua/lsp-status.nvim',
        event = "LspAttach"
    },
    {
        'terrastruct/d2-vim',
        ft = "d2",
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^3', -- Recommended
        ft = { 'rust' },
        config = function()
            require 'setup.rtools'
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function() require("dapui").setup() end
    },
    {
        "mfussenegger/nvim-dap",
        -- event = "LspAttach",
        config = function()
            local dap = require('dap')
            local registry = require('mason-registry').get_package("codelldb");
            local codelldb = registry:get_install_path() .. "/codelldb"
            dap.adapters.codelldb = {
                type = 'server',
                port = "${port}",
                executable = {
                    -- CHANGE THIS to your path!
                    command = codelldb,
                    args = { "--port", "${port}" },

                    -- On windows you may have to uncomment this:
                    -- detached = false,
                }
            }
            local program = function()
                return vim.ui.select({
                }, {
                    prompt = "Select program to debug: ",
                    format_item = function(item)
                        return item
                    end,
                })
            end
            dap.configurations.rust = {
                {
                    name = "Launch Rust (CODELLDB)",
                    type = "codelldb",
                    request = "launch",
                    program = program,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                },
            }
        end

    },
    {
        'simrat39/symbols-outline.nvim',
        cmd = "SymbolsOutline",
        config = function()
            require('symbols-outline').setup()
        end
    },
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        config = function()
            require("lspsaga").setup({
                ui = {
                    code_action = 'A'
                }
            })
        end,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            { "nvim-treesitter/nvim-treesitter" }
            --Please make sure you install markdown and markdown_inline parser
        }
    },
    {
        "ron-rs/ron.vim",
        ft = "ron",
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "LspAttach",
        config = function()
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
        end
    },
}, {
    defaults = {
        lazy = true,
    }
});
