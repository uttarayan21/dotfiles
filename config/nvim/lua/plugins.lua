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

    use 'christianrondeau/vim-base64'

    use {
      'NTBBloodbath/galaxyline.nvim', branch = 'main',
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

    use 'yuttie/comfortable-motion.vim'

    use 'ruanyl/vim-gh-line'

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
    -- use { 'onsails/lspkind-nvim', config = function() require'lspkind'.init() end, }
    use { 'folke/lsp-trouble.nvim', config = function() require("trouble").setup() end, }

    use { 'neovim/nvim-lspconfig', config = function() require("lsp") end, }
    use { 'williamboman/nvim-lsp-installer' }
    use { 'nvim-lua/lsp-status.nvim' }



    use { 'ray-x/cmp-treesitter' }
    use { 'andersevenrud/cmp-tmux' }
    use { 'hrsh7th/cmp-vsnip' }
    use { 'hrsh7th/vim-vsnip' }
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-buffer' }
    use { 'hrsh7th/cmp-path' }
    use { 'hrsh7th/cmp-cmdline' }
    use { 'hrsh7th/nvim-cmp',
        config = function() 
            local cmp = require("cmp")
            cmp.setup({
            snippet = {
              -- REQUIRED - you must specify a snippet engine
              expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
              end,
            },
            mapping = {
              ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
              ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
              ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
              ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
              ['<C-e>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
              }),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            },
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'vsnip' }, -- For vsnip users.
            }, {
              { name = 'buffer' },
              { name = 'tmux' },
              { name = 'treesitter' },
              -- { name = 'snippy' }, -- For snippy users.
            })
        }) end,
    }



    -- use { 'ms-jpq/coq_nvim', requires =  { 'ms-jpq/coq.artifacts' } }

    -- use { 'folke/lsp-colors.nvim',
    --     config = function() require("lsp-colors").setup({
    --       Error = "#db4b4b",
    --       Warning = "#e0af68",
    --       Information = "#0db9d7",
    --       Hint = "#10B981"
    --     }) end,
    -- }
    -- use 'nvim-lua/lsp_extensions.nvim'
        -- config = function() vim.cmd([[autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints()]]) end,
	--
    -- Qol
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
    -- use { 'justinmk/vim-sneak' }
    use {
        'akinsho/nvim-toggleterm.lua',
        config = function() require'setup.toggleterm' end,
    }

    -- use 'airblade/vim-rooter'
    use 'glepnir/dashboard-nvim'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }


    use {
        -- 'rust-lang/rust.vim',
        'mhinz/vim-crates',
        -- 'cespare/vim-toml',
    }

    -- use 'ms-jpq/chadtree'
    use 'tomlion/vim-solidity'
    use 'ellisonleao/glow.nvim'

end);

