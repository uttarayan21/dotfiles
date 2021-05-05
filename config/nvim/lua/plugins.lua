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

    use { 'onsails/lspkind-nvim', config = function() require'lspkind'.init() end, }
    use { 'folke/lsp-trouble.nvim', config = function() require("trouble").setup {} end, }
    use { 'neovim/nvim-lspconfig', config = function() require("lsp") end, }
    use { 'nvim-lua/completion-nvim' }

end)
