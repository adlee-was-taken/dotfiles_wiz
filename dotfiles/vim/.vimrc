" ============================================================================
" Vim Configuration - Part of dotfiles_wiz
" ============================================================================

" Basic settings
set nocompatible              " Use Vim settings, not Vi
syntax on                     " Enable syntax highlighting
filetype plugin indent on     " Enable file type detection

" Interface
set number                    " Show line numbers
set relativenumber            " Relative line numbers
set showcmd                   " Show command in bottom bar
set cursorline                " Highlight current line
set wildmenu                  " Visual autocomplete for command menu
set showmatch                 " Highlight matching brackets
set ruler                     " Show cursor position

" Indentation
set tabstop=4                 " Number of visual spaces per TAB
set softtabstop=4             " Number of spaces in tab when editing
set shiftwidth=4              " Number of spaces to use for autoindent
set expandtab                 " Tabs are spaces
set autoindent                " Copy indent from current line
set smartindent               " Smart autoindenting

" Search
set incsearch                 " Search as characters are entered
set hlsearch                  " Highlight search matches
set ignorecase                " Ignore case when searching
set smartcase                 " Override ignorecase if search contains uppercase

" Performance
set lazyredraw                " Redraw only when needed
set ttyfast                   " Faster scrolling

" Backup and swap
set nobackup                  " No backup files
set noswapfile                " No swap files
set nowritebackup             " No backup while writing

" Colors
set background=dark           " Dark background
set t_Co=256                  " 256 colors

" Status line
set laststatus=2              " Always show status line
set statusline=%F             " Full path
set statusline+=%m            " Modified flag
set statusline+=%r            " Readonly flag
set statusline+=%=            " Switch to right side
set statusline+=%l/%L         " Line/Total lines
set statusline+=\ %c          " Column number

" Key mappings
let mapleader = ","           " Leader key

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" Save with Ctrl+S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Quick quit
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Tab navigation
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>th :tabprevious<CR>
nnoremap <leader>tl :tabnext<CR>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Visual mode improvements
vnoremap < <gv
vnoremap > >gv

" Auto-commands
autocmd BufWritePre * :%s/\s\+$//e  " Remove trailing whitespace on save

" File type specific settings
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType javascript,typescript,json setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType html,css,scss setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType yaml,yml setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType markdown setlocal wrap linebreak

" Plugins (if using vim-plug)
" Uncomment and install vim-plug: https://github.com/junegunn/vim-plug
"
" call plug#begin('~/.vim/plugged')
" Plug 'tpope/vim-sensible'
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-commentary'
" call plug#end()
