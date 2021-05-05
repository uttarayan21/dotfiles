"#################################################
"#        Vim Plug
"##################################################
call plug#begin()
" QOL
    Plug 'airblade/vim-rooter'
    Plug 'yuttie/comfortable-motion.vim'
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
    Plug 'folke/which-key.nvim'
    Plug 'kdav5758/TrueZen.nvim'
    Plug 'norcalli/nvim-colorizer.lua'

" Fzf
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

" Statusline
    Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
" Tpope
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-speeddating'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
" Rust
    " Plug 'arzg/vim-rust-syntax-ext'
    Plug 'rust-lang/rust.vim'
    Plug 'mhinz/vim-crates'
    Plug 'cespare/vim-toml'
" LSP
    Plug 'onsails/lspkind-nvim'
    Plug 'folke/lsp-trouble.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'
    " Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Ctags
    Plug 'ludovicchabant/vim-gutentags'
    " Plug 'majutsushi/tagbar'
" GUI
   " Plug 'uttarayan21/minimalist'  " Plug 'dikiaap/minimalist'
    Plug 'sainnhe/sonokai'
    Plug 'kyazdani42/nvim-web-devicons' 
    Plug 'Yggdroot/indentLine'
" Text Objects
    Plug 'wellle/targets.vim'
" Dictionary
    Plug 'reedes/vim-wordy'
" Debug
    Plug 'epheien/termdbg'
" Mail
    Plug 'soywod/himalaya', {'rtp': 'vim'}

call plug#end()

"##################################################
"#       Configurations
"##################################################

" set font
set guifont=FiraCode\ Nerd\ Font\ Mono

" Undo
set undodir=~/.cache/nvim/nvimdid
set undofile

set timeoutlen=300

" Numbers and tabs
set noshowmode
set showtabline=2
" set number relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set signcolumn=yes
set hidden
set ignorecase
set smartcase
set termguicolors
" set foldmethod=indent
" set cmdheight=2

nnoremap <silent> <F2> :set number! relativenumber! <CR>
nnoremap <silent> <F3> :IndentLinesToggle <CR>

inoremap <C-j> <ESC> 

let mapleader = "\<Space>"

" BufferNext
nnoremap <Leader>q        :bw <CR>
nnoremap <leader><leader> <c-^>
nnoremap <leader>n        :bnext <CR>
nnoremap <leader>p        :bprev <CR>
" Fzf
nnoremap <silent> <Leader>f :Files <CR>
nnoremap <silent> <Leader>; :Buffers <CR>
nnoremap <silent> <Leader>g :Rg <CR>
nnoremap <Leader>H :Himalaya <CR>
nnoremap <Leader>c "+y
nnoremap <Leader>v "+p

nnoremap <silent> <Leader>r :registers <CR>
nnoremap <F8> :Tags <CR>
nnoremap <silent> <Leader>z :call ZenToggle() <CR>
nnoremap <silent> <Leader>o :LspTroubleToggle <CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Keymaps for lspconfig

" nnoremap gD   :lua vim.lsp.buf.declaration()<CR>
" nnoremap <Leader>q, <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>

nnoremap <silent> gd           :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K            :lua vim.lsp.buf.hover()<CR>, opts)
nnoremap <silent> gi           :lua vim.lsp.buf.implementation() <CR>
nnoremap <silent> <C-k>        :lua vim.lsp.buf.signature_help()<CR>

nnoremap <silent> <Leader>wa   :lua vim.lsp.buf.add_workspace_folder()<CR>
nnoremap <silent> <Leader>wr   :lua vim.lsp.buf.remove_workspace_folder()<CR>
nnoremap <silent> <Leader>wl   :lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>

nnoremap <silent> <Leader>D    :lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <Leader>rn   :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <Leader>ca   :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gr           :lua vim.lsp.buf.references()<CR>, opts)
nnoremap <silent> <Leader>e    :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> [d           :lua vim.lsp.diagnostic.goto_prev()<CR>, opts)
nnoremap <silent> ]d           :lua vim.lsp.diagnostic.goto_next()<CR>, opts)

  


" Vim hardmode
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" nnoremap <C-k> <C-]> 
" nnoremap <C-l> <C-t>

" Disable help on F1
nnoremap <F1> <ESC>
inoremap <F1> <ESC>

" Ctags
let g:gutentags_cache_dir = expand('~/.cache/nvim/ctags/')
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

" Markdown Preview
" let g:mkdp_auto_start = 1
let g:mkdp_filetypes = ['markdown']
let g:indentLine_char = '▏'
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2

"A few more remaps
nnoremap <silent> <C-s> :source ~/.config/nvim/init.vim <CR>
nnoremap <silent> <Leader>m :call Mpcfzf() <CR>


" COC
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
" inoremap <silent><expr> <c-space> coc#refresh()
" nnoremap <silent> K :call <SID>show_documentation()<CR>
" nnoremap <Leader>l :CocCommand <CR>


augroup AutoSaveGroup
  autocmd!
  " view files are about 500 bytes
  " bufleave but not bufwinleave captures closing 2nd tab
  " nested is needed by bufwrite* (if triggered via other autocmd)
  " BufHidden for for compatibility with `set hidden`
  autocmd BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup end

" Comment no file types with #
autocmd BufNewFile,BufRead * if empty(&filetype) | setlocal commentstring=#\ %s | endif
" autocmd BufRead urls set commentstring=#\ %s
" set commentstring=#\ %s


" Do not edit readonly buffers
autocmd BufRead *.orig set readonly
autocmd BufRead *.pacnew set readonly
autocmd BufRead *.bak set readonly
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
autocmd FileType netrw setl bufhidden=wipe
let g:netrw_fastbrowse = 0

" Toggle crates plugin on opening cargo.toml file
autocmd BufRead Cargo.toml call crates#toggle()


" Set python global file
let g:python3_host_prog = "/usr/bin/python"
" asmsyntax always nasm
let g:asmsyntax = 'nasm'
" set nodejs global prog
" let g:node_host_prog = "/usr/bin/neovim-node-host"

" Themeing
syntax on
let g:sonokai_style = "default"
let g:sonokai_transparent_background = 1
colorscheme sonokai

hi link Crates WarningMsg

if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
endif
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

" Rust
let g:rustfmt_autosave = 1

nnoremap <silent> <leader>da :call <SID>AppendBreakPoint()<CR>
nnoremap <silent> <leader>dc :call <SID>ClearBreakpoints()<CR>
nnoremap <silent> <leader>dr :call <SID>DebugRun()<CR> 

function! s:AppendBreakPoint()
    let s:breakpoint = "break ".expand('%').":".line('.')
    call writefile([s:breakpoint], "./target/breakpoints", "a")
    echom "Added breakpoint at line ".line('.')
endfunction 

function! s:ClearBreakpoints()
    call delete("./target/breakpoints")
    echom "Cleared breakpoints"
endfunction

function! s:DebugRun()
    execute "!cargo build"
    let s:dirlist = split(getcwd(),'/')
    let s:projectname = s:dirlist[len(s:dirlist)-1]
    " let s:projectname = system('sed -n "s/^name Cargo.toml ')
    let s:executable = getcwd()."/target/debug/".s:projectname
    silent execute "!alacritty -e rust-gdb -x ./target/breakpoints ".s:executable." &"
endfunction

"##################################################
"#           Functions
"##################################################
" COC.nvim
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction

" Mpc
function Mpcfzf()
	execute("silent !mpcfzf")
endfunction
" Mpc Current song
function CurrentSong()
    let s = execute("!mpc | head -1")
    return s
endfunction

let t:zen = 1
let t:fullscreen = 1
let t:tmux = 1
function! ZenToggle()
    if t:zen == 0
        hi Normal guibg=NONE ctermbg=NONE
        hi NonText guibg=NONE ctermbg=NONE
        TZMinimalistT
        if t:tmux == 1
            silent! !tmux set -g status on
        endif
        if t:fullscreen == 1
            silent! !bspc node focused -f -t tiled
        endif
        let t:zen = 1
    else 
        hi Normal ctermfg=255 ctermbg=234 cterm=NONE guifg=#EEEEEE guibg=#1C1C1C gui=NONE
        hi NonText ctermfg=234 ctermbg=234 cterm=NONE guifg=#1C1C1C guibg=#1C1C1C gui=NONE
        TZMinimalistF
        if t:tmux == 1
            silent! !tmux set -g status off
        endif
        if t:fullscreen == 1
            silent! !bspc node focused -f -t fullscreen
        endif
        let t:zen = 0
    endif
endfunction

" ########################################
" #         LUA
" ########################################


" Which key
lua << EOF
require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
}
-- Lspkind-nvim
require'lspkind'.init()

-- Colorizer
require'colorizer'.setup()

-- lsp trouble
require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
}
require("lsp");
require("scripts.status-line");
-- require("scripts.eviline");
require("scripts.truezen");
EOF
