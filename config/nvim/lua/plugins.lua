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
    'ellisonleao/glow.nvim',
    'samoshkin/vim-mergetool',

    'mhartington/formatter.nvim',
    'christianrondeau/vim-base64',

    'tpope/vim-commentary',
    'tpope/vim-fugitive',
    'tpope/vim-repeat',
    'tpope/vim-speeddating',
    'tpope/vim-surround',
    'tpope/vim-vinegar',
    'tpope/vim-abolish',

    'yuttie/comfortable-motion.vim',
    'ruanyl/vim-gh-line',
    'rest-nvim/rest.nvim',
    'b0o/SchemaStore.nvim',
    'rcarriga/nvim-notify',
    'folke/todo-comments.nvim',

    { 'folke/zen-mode.nvim', config = function() require('zen-mode').setup() end },
    { 'folke/twilight.nvim', config = function() require('twilight').setup() end },

    {
        'utilyre/barbecue.nvim',
        version = "*",
        config = function() require('barbecue').setup() end,
        dependencies = {
            'neovim/nvim-lspconfig',
            'SmiteshP/nvim-navic',
            'nvim-tree/nvim-web-devicons'
        },
    },

    { 'akinsho/git-conflict.nvim',
        version = "*",
        config = function()
            require('git-conflict').setup()
        end
    },

    { 'williamboman/mason.nvim',
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
                ensure_installed = { "sumneko_lua", "rust_analyzer", "gopls" },
                automatic_installation = true,
            })
        end
    },

    {
        'NTBBloodbath/galaxyline.nvim', branch = 'main',
        config = function() require('statusline') end,
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    { 'sainnhe/sonokai', config = function() require('colorscheme') end },
    { 'folke/which-key.nvim', config = function() require("which-key").setup() end },
    { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
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


    { 'norcalli/nvim-colorizer.lua', config = function() require 'colorizer'.setup() end, },

    -- lsp
    -- use { 'onsails/lspkind-nvim', config = function() require'lspkind'.init() end, }
    {
        'folke/trouble.nvim',
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

    { 'neovim/nvim-lspconfig', config = function() require("lsp") end, },
    { 'nvim-lua/lsp-status.nvim' },

    { 'ms-jpq/coq_nvim', dependencies = { 'ms-jpq/coq.artifacts' }, build = ':COQdeps' },
    { 'ms-jpq/chadtree', build = ':CHADdeps' },
    { 'ms-jpq/coq.thirdparty', config = function()
        require("coq_3p")({
            {
                src = "repl",
                sh = "sh",
                shell = { p = "perl", n = "node" },
                max_lines = 99,
                deadline = 500,
                unsafe = { "rm", "poweroff", "mv" }
            },
            { src = "bc", short_name = "MATH", precision = 6 },
            { src = "copilot", short_name = "COP", accept_key = "<C-l>" },
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

    { 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' },
    {
        'akinsho/toggleterm.nvim',
        config = function() require 'setup.toggleterm' end,
    },

    {
        'glepnir/dashboard-nvim',
        config = function() require 'setup.dashboard' end,
    },
    'github/copilot.vim',

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },



    {
        'saecki/crates.nvim',
        tag = 'v0.2.1',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup {
                src = {
                    coq = {
                        enabled = true,
                        name = "crates.nvim",
                    },
                },
            }
        end,
    },
    { 'simrat39/rust-tools.nvim', config = function() require 'setup.rust-tools' end },


    {
        "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" },
        config = function() require("dapui").setup() end
    },

    {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
        end
    },

});
