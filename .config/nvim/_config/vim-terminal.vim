scriptencoding utf-8

if has('nvim')
  let $GIT_EDITOR = 'nvr'
endif

if empty(globpath(&rtp, 'autoload/neoterm.vim'))
  finish
endif

" new terminal
" nnoremap <Space>t :vs Terminal<CR>

" toggle Terminal.
nnoremap <C-t><C-t> :Ttoggle<CR>
tnoremap <C-t><C-t> <C-\><C-n>:Ttoggle<CR>

nnoremap <C-t>r :T node %<CR>
nnoremap <C-t>g :T tig<CR>
nnoremap <C-t>n :Tnew<CR>

let g:neoterm_autoinsert = 1
let g:neoterm_autoscroll = 1
let g:neoterm_default_mod = "vertical belowright"
"let g:neoterm_default_mod = "belowright"

" 画面分割の説明
" https://vim-jp.org/vim-users-jp/2011/01/31/Hack-198.html
