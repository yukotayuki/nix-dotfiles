scriptencoding utf-8


"let mapleader = "\<Space>"
let mapleader = "\\"

" vim-terminal内でterminal-normalモードに移行する
tnoremap <Esc><Esc> <C-\><C-n>
"tnoremap <Space><Esc> <C-\><C-n>

nnoremap <Space>w :w<CR>
nnoremap <Space>q :qa<CR>
nnoremap <C-c> :bd<CR>
nnoremap <Space>d :vs<CR>
nnoremap <Space><S-d> :sp<CR>
"nnoremap <Space><Space> :set expandtab<CR>

" open setting files
" nnoremap <Space>, :edit $MYVIMRC<CR>
nnoremap <Space>, :edit $DOTDIR/.config/nvim/init.vim<CR>
nnoremap ,t :edit ~/.config/nvim/toml<CR>

" 移動
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Right> <C-f>
nnoremap <Left> <C-b>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-e> <End>
inoremap <C-a> <Home>
inoremap <C-l> <Esc>

" pain keybind
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap s. <C-w>>
nnoremap s, <C-w><
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H

" tab keybind
for n in range(1, 9)
  execute 'nnoremap <silent> t' .n  ':<C-u>tabnext'.n.'<CR>'
endfor

noremap <silent> tt :tablast <bar> tabnew<CR>
noremap <silent> tc :tabclose<CR>
noremap <silent> tn :tabnext<CR>
noremap <silent> tp :tabprevious<CR>

nnoremap <C-e> :<C-u>CtrlPLauncher<CR>


if has('mac')
  autocmd BufNewFile,BufRead *.md nnoremap <Space>r :PrevimOpen<CR>
"elseif has('unix')
endif
