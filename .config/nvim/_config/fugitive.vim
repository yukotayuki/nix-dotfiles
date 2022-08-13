if empty(globpath(&rtp, 'autoload/fugitive.vim'))
  finish
endif

" let g:fugitive_no_maps = 1

" autocmd MyAutoCmd WinEnter * if exists('b:git_dir') | let g:git_dir = b:git_dir | endif
" 
" autocmd MyAutoCmd BufRead,BufNewFile * if exists('g:git_dir') | let b:git_dir = g:git_dir | endif
" 
command! -nargs=0 Gv call s:vsplit_fugitive()

function! s:vsplit_fugitive()
    :belowright vertical G
endfunction
