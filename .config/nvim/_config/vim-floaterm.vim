if empty(globpath(&rtp, 'autoload/floaterm.vim'))
  finish
endif

" tnoremap <leader>tn <C-\><C-n>:FloatermNew<CR>
" tnoremap <leader>[ <C-\><C-n>:FloatermNext<CR>
" tnoremap <leader>] <C-\><C-n>:FloatermPrev<CR>
tnoremap <Space>t <C-\><C-n>:FloatermToggle<CR>
nnoremap <Space>t :FloatermToggle<CR>
" tnoremap <leader>td <C-\><C-n>:FloatermKill!<CR>

augroup vimrc_floaterm
  autocmd!
  autocmd QuitPre * FloatermKill!
augroup END
