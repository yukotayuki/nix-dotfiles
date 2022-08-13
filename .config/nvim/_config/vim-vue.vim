" https://github.com/posva/vim-vue#my-syntax-highlighting-stops-working-randomly
" vueファイルのシンタックスが効かなくなる問題対応
augroup vim-vue
  autocmd! *
  autocmd FileType vue syntax sync fromstart
augroup END
