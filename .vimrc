set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim/
call vundle#begin('$HOME/.vim/bundle/')
"call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree.git'
Plugin 'godlygeek/tabular.git'
Plugin 'vim-syntastic/syntastic'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'majutsushi/tagbar'
Plugin 'taglist.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
"Plugin 'weynhamz/vim-plugin-minibufexpl'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'bling/vim-bufferline'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
"Plugin 'easymotion/vim-easymotion'
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/vimshell.vim'
call vundle#end()            " required
filetype plugin indent on    " required

set encoding=utf-8
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
"set guifont=DejaVu_Sans_Mono_for_Powerline:h10
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

set number                      " Line numbers on
set rnu                         " Relative numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set hidden
set cursorline
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set nowrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent

"let g:tlist_vhdl_settings = 'vhdl;s:signals;d:package declarations;b:package bodies;e:entities;a:architecture specifications;t:type declarations;p:processes;f:functions;r:procedures'

" search first in current directory then file directory for tag file
set tags=tags,./tags

syntax enable
set background=light
"set background=dark
colorscheme solarized
let mapleader = ","
cmap qa qa!<CR>
nnoremap <C-L> :nohlsearch<CR><C-L>
" Toggle show/hide invisible chars
nnoremap <leader>i :set list!<cr>

au InsertEnter * set nocul
au InsertLeave * set cul

"highlight OverLength guibg=#592929
"match OverLength /\%>80v.\+/

" Edit the vimrc file
noremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>sv :so $MYVIMRC<CR>

" Quickly get out of insert mode without your fingers having to leave the
" home row (either use 'jj' or 'jk')
inoremap <C-h> <Esc>

" Speed up scrolling of the viewport slightly
nnoremap <C-e> 2<C-e>
noremap <C-y> 2<C-y>

" Pull word under cursor into LHS of a substitute (for quick search and
" replace)
"nnoremap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#
nnoremap <leader>z :%s/\<<C-r><C-w>\>//gc<left><left><left>
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprevious<CR>

map <leader>g :NERDTreeToggle<CR>

nmap <leader>a= :Tabularize /=
vmap <leader>a= :Tabularize /=
nmap <leader>a: :Tabularize /:
vmap <leader>a: :Tabularize /:
nmap <leader>ax :Tabularize /
vmap <leader>ax :Tabularize /

set laststatus=2

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
"let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_splits = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
"let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 's'
let g:airline_powerline_fonts=1

nmap <leader>t :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_compact = 1
let g:tagbar_show_linenumbers = 1

let g:tagbar_type_vhdl = {
    \ 'ctagstype' : 'vhdl',
    \ 'kinds'     : [
        \ 's:signal',
        \ 'v:variable',
        \ 'P:ports',
        \ 'p:processes',
        \ 'a:architecture-specifications',
        \ 'e:entities'
    \ ],
    \ 'sort'        : 0
\ }

nmap <leader>l :TlistToggle<CR>
let Tlist_Enable_Fold_Column = 0
let Tlist_GainFocus_On_ToggleOpen = 1

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
nmap <leader>es :UltiSnipsEdit<CR>
let g:UltiSnipsExpandTrigger="<c-b>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetsDir = $HOME.'/.vim/mysnippets'
let g:UltiSnipsSnippetDirectories = ["mysnippets"]
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"nmap <leader>b :MBEToggle<CR> :MBEFocus<CR>

nmap <leader>ft :CtrlPTag<CR>
nmap <leader>fb :CtrlPBuffer<CR>

let g:ctrlp_map = '<leader>ff'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'w'
"let g:ctrlp_clear_cache_on_exit=0
"let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
"      \ --ignore .git
"      \ --ignore .svn
"      \ --ignore .hg
"      \ --ignore .DS_Store
"      \ --ignore "**/*.pyc"
"      \ -g ""'
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 0
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 1
let g:syntastic_vhdl_checkers = ["xvhdl"]
