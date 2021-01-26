"#################################################
"#        Vim Plug
"##################################################
call plug#begin()
" QOL
    Plug 'airblade/vim-rooter'
    Plug 'w0rp/ale'
    Plug 'yuttie/comfortable-motion.vim'
    Plug 'tpope/vim-surround'
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" Fzf
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
" Git plugin
    Plug 'tpope/vim-fugitive'

" GUI Stuff
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " Plug 'edkolev/tmuxline.vim'
	Plug 'tpope/vim-commentary'
    Plug 'uttarayan21/minimalist'  " Plug 'dikiaap/minimalist'
    Plug 'dracula/vim'
    Plug 'tpope/vim-vinegar'
    Plug 'mhinz/vim-crates'
" Intellisense
    Plug 'neoclide/coc.nvim', {'branch': 'release'}    
" Ctags
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'majutsushi/tagbar'
" Syntax Highlighting
    Plug 'rust-lang/rust.vim'
    Plug 'sudar/vim-arduino-syntax'
    Plug 'cespare/vim-toml'
    Plug 'chaimleib/vim-renpy'
    Plug 'udalov/kotlin-vim'
    Plug 'meain/vim-package-info'
" Devicons
    Plug 'ryanoasis/vim-devicons'
" Text Objects
    Plug 'wellle/targets.vim'
call plug#end()

"##################################################
"#       Configurations
"##################################################

" Remap C-h,j,k,l
"nnoremap <C-h> <C-w>h
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-l> <C-w>l

" nnoremap <C-j> <ESC>
inoremap <C-j> <ESC> 

let mapleader = "\<Space>"
" BufferNext
nnoremap <Leader>q        :bw <CR>
"nnoremap <Leader><Leader> :bNext <CR>
nnoremap <leader><leader> <c-^>
nnoremap <leader>n        :bnext <CR>
nnoremap <leader>p        :bprev <CR>
" Fzf
nnoremap <Leader>f :Files <CR>
nnoremap <Leader>b :Buffers <CR>
nnoremap <Leader>w :W <CR>
nnoremap <Leader>g :Rg <CR>
nnoremap <Leader>t :Tags <CR>

nnoremap <F8> :TagbarToggle <CR>


" Vim hardmode
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" Undo
set undodir=~/.cache/nvim/nvimdid
set undofile

" Disable help on F1
nnoremap <F1> <ESC>
inoremap <F1> <ESC>

" Ctags
let g:gutentags_cache_dir = expand('~/.cache/nvim/ctags/')
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
nnoremap <C-k> <C-]> 
nnoremap <C-l> <C-t>

" Markdown Preview

" let g:mkdp_auto_start = 1
let g:mkdp_filetypes = ['markdown']
" let g:mkdp_broswer = 'qutebrowser'


" Numbers and tabs
set noshowmode
set showtabline=2
setlocal number relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set signcolumn=yes
set hidden
set ignorecase
set smartcase
"set cmdheight=2

nnoremap <F2> :set number! relativenumber! <CR>


"A few more remaps
nnoremap <C-s> :source ~/.config/nvim/init.vim <CR>
nnoremap <Leader>m :call Mpcfzf() <CR>

" Intellisense

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <silent><expr> <c-space> coc#refresh()
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <Leader>l :CocCommand <CR>


" Clipboard
set clipboard=unnamedplus
let g:clipboard = {
    \'name': 'PrimaryClipboard',
    \'copy': {
    \   '+': 'xclip -selection clipboard',
    \   '*': 'xclip -selection clipboard',
    \   },
    \'paste': {
    \   '+': 'xclip -selection clipboard -out',
    \   '*': 'xclip -selection clipboard -out',
    \   },
    \'cache_enabled': 1,
    \}


augroup linenumbers 
    autocmd WinLeave * :setlocal nonumber norelativenumber
    autocmd WinEnter * :setlocal number relativenumber
augroup END

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
" set t_Co=256
syntax on
colorscheme minimalist
" let g:dracula_colorterm = 0
" colorscheme dracula

highlight link Crates WarningMsg
" colorscheme nord

if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
endif
" set termguicolors

" Airline
let g:airline_theme='dracula'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" let g:airline_statusline_ontop = 1

" " Tmuxline
" let g:tmuxline_preset = {
"       \'a'    : '#S',
"       \'b'    : '#W',
"       \'c'    : '#H',
"       \'win'  : '#I #W',
"       \'cwin' : '#I #W',
"       \'x'    : '%a',
"       \'y'    : '#W %R',
"       \'z'    : '#H'}

" Lightline
" let g:lightline = {}
" let g:lightline.colorscheme = 'darcula'
" " let g:lightline.colorscheme = 'wombat'
" let g:lightline.active = {}
" let g:lightline.active.left =  [['mode', 'paste'] ,['readonly', 'filename', 'modified']]
" let g:lightline.active.right = [['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype', 'charvaluehex']]
" let g:lightline.separator = { 'left': "\ue0b8", 'right': "\ue0ba" }
" let g:lightline.subseparator = { 'left': "\ue0b9", 'right': "\ue0bb" }

" let g:lightline.tabline = {}
" let g:lightline.tabline.left = [['buffers']]
" let g:lightline.tabline.right = [['close'], ['gitbranch']]
" let g:lightline.tabline_separator = { 'left': "\ue0bc", 'right': "\ue0be" }
" let g:lightline.tabline_subseparator = { 'left': "\ue0bd", 'right': "\ue0bf" }

" let g:lightline.component_function = { 'song': 'CurrentSong', 'gitbranch': 'FugitiveHead' }
" let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
" let g:lightline.component_type   = {'buffers': 'tabsel'}

" Rust
" let g:rustfmt_autosave = 1

"##################################################
"#           Functions
"##################################################
" COC.nvim
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Mpc
function Mpcfzf()
	execute("silent !mpcfzf")
endfunction
" Mpc Current song
function CurrentSong()
    let s = execute("!mpc | head -1")
    return s
endfunction
