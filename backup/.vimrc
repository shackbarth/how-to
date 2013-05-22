set background=dark
colorscheme ir_black
" colorscheme nazca
set nocompatible
" set autoindent
set smartindent
set expandtab
" set tabstop=8
set tabstop=4
set shiftwidth=2
set smarttab
set showmatch
set ruler
set incsearch
set nu
syntax on

" filetype plugin indent on for makefiles since they
" are so picky
autocmd BufEnter ?akefile* set noet ts=8 sw=8

" open SC Buildfile's with ruby
autocmd BufEnter Buildfile set filetype=ruby

" automatically remove trailing whitespace from javascript and html files
autocmd BufWritePre *.js :%s/\s\+$//e
autocmd BufWritePre *.html :%s/\s\+$//e

" fix common styling mistakes. 
autocmd BufWritePre *.js :%s/function(/function (/e
autocmd BufWritePre *.js :%s/for(/for (/e
autocmd BufWritePre *.js :%s/if(/if (/e

" no BOM
autocmd BufWritePre *.sql :set nobomb

call pathogen#infect()
" map nerdtree for convenience
map <F2> :NERDTreeToggle<cr>
map <F5> :w<cr>:JSHint<cr>:cw<cr>
