local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    execute 'packadd packer.nvim'
end


return require('packer').startup(function()
  -- Packer can manage itself
    use 'wbthomason/packer.nvim'


    use {
        'glepnir/galaxyline.nvim', branch = 'main',
        config = function() require('statusline') end,
        requires = { 'kyazdani42/nvim-web-devicons' }
    }

    use {
        'sainnhe/sonokai',
        config = function() require('colorscheme') end,
    }

    use {
        'folke/which-key.nvim',
        config = function() require("which-key").setup() end,
    }

    use { 'yuttie/comfortable-motion.vim' }

    use {
        'junegunn/fzf',
        requires =  { 'junegunn/fzf.vim' }
    }

    use {
        'tpope/vim-surround',
        'tpope/vim-vinegar',
        'tpope/vim-repeat',
        'tpope/vim-speeddating',
        'tpope/vim-commentary',
        'tpope/vim-fugitive',
    }

    use { 'norcalli/nvim-colorizer.lua', config = function() require'colorizer'.setup() end, }

    -- lsp
    use { 'onsails/lspkind-nvim', config = function() require'lspkind'.init() end, }
    use { 'folke/lsp-trouble.nvim', config = function() require("trouble").setup() end, }

    use { 'neovim/nvim-lspconfig', config = function() require("lsp") end, }
    use { 'nvim-lua/lsp-status.nvim' }
    

    use {
        'hrsh7th/nvim-cmp',
        requires = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'saadparwaiz1/cmp_luasnip', 'L3MON4D3/LuaSnip' },
        config = function() require'nvim-cmp' end,
    }

    use { 'folke/lsp-colors.nvim' }
    use { 'nvim-lua/lsp_extensions.nvim' }
        -- config = function() vim.cmd([[autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints()]]) end,
	--
    -- Qol
	use { 'sindrets/diffview.nvim' }
    -- use { 'justinmk/vim-sneak' }
    use { 
        'akinsho/nvim-toggleterm.lua',
        config = function() require'setup.toggleterm' end,
    }

    use { 'airblade/vim-rooter' }
    use { 'glepnir/dashboard-nvim' }

    --  Treesitter {{{
    -- use { 'nvim-treesitter/nvim-treesitter' }
    -- use { 'nvim-treesitter/completion-treesitter' }
    --- }}}

    --: rust {{{
    use {
        'rust-lang/rust.vim',
        'mhinz/vim-crates',
        'cespare/vim-toml',
    }
    -- }}}
    use { 'vim-python/python-syntax' }
end)
