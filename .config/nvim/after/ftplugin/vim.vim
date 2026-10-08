if exists("b:did_ftplugin_vim")
  finish
endif

let b:did_ftplugin_vim=1

" add path {{{
set path+=~/.vim
"}}}

" key map {{{

" }}}

" indent {{{
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set autoindent
set smartindent
" }}}

" folding {{{
set foldmethod=marker
set autoindent
"set smartindent
" set number
set nofoldenable
" }}}
