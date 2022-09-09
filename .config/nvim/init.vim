autocmd!

if has('vim_starting')
  set encoding=utf-8
  scriptencoding utf-8
  
  if !has('gui_running') && has('termguicolors')
    if !has('nvim')
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    set termguicolors
  endif
  
  "set noerrorbells
  set belloff=all
endif

set helplang=ja,en
set nospell
" set number

" showtabline : always => 2
set showtabline=2

" visualize tab, space and enter
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

set autoindent
"set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" change color from over 80 lines
let &colorcolumn="80,".join(range(81,999),",")

if has('clipboard')
  set clipboard=unnamedplus
  set clipboard+=unnamed
endif

" vimでbackspaceを有効に
set backspace=indent,eol,start

runtime! vimplug.vim
runtime! keymaps.vim
runtime! _config/*.vim

syntax enable
filetype indent plugin on

if has('termguicolors')
  " unlet! ayucolor
  " let ayucolor='mirage'

  let colorschemes = getcompletion('', 'color')
  " if match(colorschemes, 'ayu') != -1
  if match(colorschemes, 'nord') != -1
    " colorscheme ayu
    colorscheme nord
  else
    colorscheme default
  endif

else
  colorscheme default
endif

set path+=~/.vim


" 良さげなプラグインの紹介
" https://aiya000.github.io/Maid/vimconf.swp.2018/#/57
