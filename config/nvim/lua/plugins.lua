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
    { "ellisonleao/glow.nvim", config = true,                                                                                                   cmd = "Glow" },
    'samoshkin/vim-mergetool',
    'mhartington/formatter.nvim',
    -- 'christianrondeau/vim-base64',

    { 'tpope/vim-commentary',  lazy = false },
    { 'tpope/vim-fugitive',    cmd = { "Git", "Gdiffsplit", "Gvdiffsplit", "Gedit", "Gread", "Gwrite", "Ggrep", "Gbrowse", "GMove", "GDelete" } },
    'tpope/vim-repeat',
    'tpope/vim-speeddating',
    { 'tpope/vim-surround',            lazy = false },
    'tpope/vim-vinegar',
    'tpope/vim-abolish',
    { 'yuttie/comfortable-motion.vim', event = "BufEnter" },
    -- 'ruanyl/vim-gh-line',
    { 'rest-nvim/rest.nvim',           event = "BufEnter" },
    -- 'b0o/SchemaStore.nvim',
    -- 'rcarriga/nvim-notify',
    { 'folke/todo-comments.nvim',      event = "BufEnter" },
    { 'github/copilot.vim',            event = "LspAttach", cmd = "Copilot" },
    -- 'ggandor/leap.nvim',
    {
        'shortcuts/no-neck-pain.nvim',
        cmd = { "NoNeckPain", "NoNeckPainResize", "NoNeckPainScratchPad", "NoNeckPainWidthUp", "NoNeckPainWidthDown" },
        version = "*"
    },
    -- { 'folke/zen-mode.nvim',         config = function() require('zen-mode').setup() end },
    -- { 'folke/twilight.nvim',         config = function() require('twilight').setup() end },
    {
        'pwntester/octo.nvim', cmd = "Octo",
        config = function()
            require(
                'octo').setup()
        end
    },
    {
        'sainnhe/sonokai',
        lazy = false,
        config = function()
            require('colorscheme')
        end
    },
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     lazy = false,
    --     config = function()
    --         require('colorscheme')
    --     end
    -- },
    {
        {
            "nvim-neorg/neorg",
            cmd = "Neorg",
            ft = "norg",
            build = ":Neorg sync-parsers",
            opts = {
                load = {
                    ["core.defaults"] = {}, -- Loads default behaviour
                    ["core.concealer"] = {}, -- Adds pretty icons to your documents
                    ["core.dirman"] = { -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/Documents/norg",
                            },
                        },
                    },
                },
            },
            dependencies = { { "nvim-lua/plenary.nvim" } },
        }
    },
    { 'folke/which-key.nvim',         config = function() require("which-key").setup() end },
    { 'nvim-telescope/telescope.nvim',
        cmd = "Telescope",
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim', 'nvim-telescope/telescope-fzf-native.nvim' }
    },
    -- {
    --     'utilyre/barbecue.nvim',
    --     event = "LspAttach",
    --     version = "*",
    --     config = function() require('barbecue').setup() end,
    --     dependencies = {
    --         'neovim/nvim-lspconfig',
    --         'SmiteshP/nvim-navic',
    --         'nvim-tree/nvim-web-devicons'
    --     },
    -- },
    {
        'akinsho/git-conflict.nvim',
        version = "*",
        config = function()
            require('git-conflict').setup()
        end
    },
    {
        'williamboman/mason.nvim',
        cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "rust_analyzer" },
                automatic_installation = true,
            })
        end
    },
    {
        'NTBBloodbath/galaxyline.nvim', branch = 'main',
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
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    }
                }
            }
            require('telescope').load_extension('fzf')
        end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            require("telescope").load_extension("ui-select")
        end
    },
    { 'norcalli/nvim-colorizer.lua',  config = function() require 'colorizer'.setup() end },
    { 'IndianBoy42/tree-sitter-just', config = function() require 'tree-sitter-just'.setup({}) end, dependencies = { "nvim-treesitter/nvim-treesitter" }, ft = "just" },
    -- lsp
    -- use { 'onsails/lspkind-nvim', config = function() require'lspkind'.init() end, }
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
    { 'neovim/nvim-lspconfig',
        ft = { "rust", "toml", "lua", "c", "cpp", "markdown", "sql" },
        config = function()
            require("lsp")
        end
    },
    {
        'nvim-lua/lsp-status.nvim',
        event = "LspAttach"
    },
    -- {
    --     'ray-x/lsp_signature.nvim',
    --     -- event = "LspAttach",
    --     config = function()
    --         require("lsp_signature").setup({
    --             floating_window_above_cur_line = true,
    --         })
    --     end,
    -- },
    {
        'terrastruct/d2-vim',
        ft = "d2",
    },
    {
        'andweeb/presence.nvim',
        config = function()
            require "presence".setup({
                auto_update = true,
                main_image = "file",
            })
        end },
    {
        'ms-jpq/coq_nvim',
        ft = { "rust", "toml", "lua" },
        dependencies = { 'ms-jpq/coq.artifacts', 'ms-jpq/coq.thirdparty' },
        build = ':COQdeps',
        config = function()
            vim.g.coq_settings.keymap = { jump_to_mark = "<c-j>" }
        end
    },
    -- { 'ms-jpq/chadtree',   build = ':CHADdeps' },
    { 'ms-jpq/coq.thirdparty',
        config = function()
            require("coq_3p")({
                {
                    src = "repl",
                    sh = "sh",
                    shell = { p = "perl", n = "node" },
                    max_lines = 99,
                    deadline = 500,
                    unsafe = { "rm", "poweroff", "mv" }
                },
                { src = "bc",      short_name = "MATH", precision = 6 },
                { src = "copilot", short_name = "COP",  accept_key = "<C-l>" },
                { src = "dap" }
            })
        end
    },
    -- use 'airblade/vim-rooter'
    -- use({
    --     "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --     config = function()
    --         require("lsp_lines").setup()
    --     end,
    -- })

    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                show_end_of_line = true,
            }
        end
    },
    { 'sindrets/diffview.nvim', cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" }, dependencies = 'nvim-lua/plenary.nvim' },
    {
        'akinsho/toggleterm.nvim',
        cmd = "ToggleTerm",
        config = function() require 'setup.toggleterm' end,
    },
    -- {
    --     'glepnir/dashboard-nvim',
    --     config = function() require 'setup.dashboard' end,
    -- },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' }
    },
    -- {
    --     'saecki/crates.nvim',
    --     tag = 'v0.2.1',
    --     dependencies = { 'nvim-lua/plenary.nvim' },
    --     config = function()
    --         require('crates').setup {
    --             src = {
    --                 coq = {
    --                     enabled = true,
    --                     name = "crates.nvim",
    --                 },
    --             },
    --         }
    --     end,
    -- },
    { 'simrat39/rust-tools.nvim', ft = 'rust', config = function()
        require 'setup.rust-tools'
    end, dependencies = "ms-jpq/coq_nvim" },
    {
        "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" },
        config = function() require("dapui").setup() end
    },
    -- {
    --     'phaazon/hop.nvim',
    --     branch = 'v2', -- optional but strongly recommended
    --     config = function()
    --         -- you can configure Hop the way you like here; see :h hop-config
    --         require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    --     end
    -- },
    -- https://github.com/simrat39/symbols-outline.nvim
    {
        'simrat39/symbols-outline.nvim',
        cmd = "SymbolsOutline",
        config = function()
            require('symbols-outline').setup()
        end
    },
    {
        "glepnir/lspsaga.nvim",
        event = "LspAttach",
        config = function()
            require("lspsaga").setup({})
        end,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            --Please make sure you install markdown and markdown_inline parser
            { "nvim-treesitter/nvim-treesitter" }
        }
    },
    {
        'j-hui/fidget.nvim',
        event = "LspAttach",
        config = function()
            require("fidget").setup({})
        end
    },
    {
        "cshuaimin/ssr.nvim",
        module = "ssr",
        -- Calling setup is optional.
        config = function()
            require("ssr").setup {
                border = "rounded",
                min_width = 50,
                min_height = 5,
                max_width = 120,
                max_height = 25,
                keymaps = {
                    close = "q",
                    next_match = "n",
                    prev_match = "N",
                    replace_confirm = "<cr>",
                    replace_all = "<leader><cr>",
                },
            }
        end
    }

}, {
    defaults = {
        lazy = true,
    }
});
