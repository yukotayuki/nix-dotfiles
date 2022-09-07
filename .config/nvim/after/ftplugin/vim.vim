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
set expandtab      " tab to space
set tabstop=2      " tabを何個分のスペースで扱うか
set shiftwidth=2   " indent width
set softtabstop=2  " insert space width(tabをトリガーに)
" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set smarttab
" 改行時に前の行のインデントを継続する
set autoindent
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" }}}

" folding {{{
set foldmethod=marker
set autoindent
"set smartindent
" set number
set nofoldenable  "折りたたみ無効
" }}}
