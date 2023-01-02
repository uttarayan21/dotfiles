local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
local use = require('packer').use

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
    execute 'packadd packer.nvim'
end


return require('packer').startup(function()
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim' }
    use { 'williamboman/mason.nvim',
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
    }
    use {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "sumneko_lua", "rust_analyzer" },
                automatic_installation = true,
            })
        end
    }

    use { 'mhartington/formatter.nvim' }

    -- use 'imsnif/kdl.vim'
    use 'christianrondeau/vim-base64'
    use {
        'NTBBloodbath/galaxyline.nvim', branch = 'main',
        config = function() require('statusline') end,
        requires = { 'kyazdani42/nvim-web-devicons' }
    }
    use { 'sainnhe/sonokai', config = function() require('colorscheme') end }
    use { 'folke/which-key.nvim', config = function() require("which-key").setup() end }
    use { 'yuttie/comfortable-motion.vim' }
    use { 'ruanyl/vim-gh-line' }
    use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } }
    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
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
    }

    use { 'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            require("telescope").load_extension("ui-select")
        end
    }


    use {
        'tpope/vim-commentary',
        'tpope/vim-fugitive',
        'tpope/vim-repeat',
        'tpope/vim-speeddating',
        'tpope/vim-surround',
        'tpope/vim-vinegar',
    }

    use { 'norcalli/nvim-colorizer.lua', config = function() require 'colorizer'.setup() end, }

    -- lsp
    -- use { 'onsails/lspkind-nvim', config = function() require'lspkind'.init() end, }
    use {
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
    }

    use { 'neovim/nvim-lspconfig', config = function() require("lsp") end, }
    use { 'nvim-lua/lsp-status.nvim' }

    use { 'ms-jpq/coq_nvim', requires = { 'ms-jpq/coq.artifacts' }, run = ':COQdeps' }
    use { 'ms-jpq/chadtree', run = ':CHADdeps' }
    use { 'ms-jpq/coq.thirdparty', config = function()
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
    }

    use 'airblade/vim-rooter'
    -- use({
    --     "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --     config = function()
    --         require("lsp_lines").setup()
    --     end,
    -- })

    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                show_end_of_line = true,
            }
        end
    }

    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
    use {
        'akinsho/toggleterm.nvim',
        config = function() require 'setup.toggleterm' end,
    }

    use {
        'glepnir/dashboard-nvim',
        config = function() require 'setup.dashboard' end,
    }
    use 'github/copilot.vim'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use 'samoshkin/vim-mergetool'


    use {
        'saecki/crates.nvim',
        tag = 'v0.2.1',
        requires = { 'nvim-lua/plenary.nvim' },
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
    }
    use { 'simrat39/rust-tools.nvim', config = function() require 'setup.rust-tools' end }

    use 'ellisonleao/glow.nvim'

    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" },
        config = function() require("dapui").setup() end }

    use {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
        end
    }

end);
