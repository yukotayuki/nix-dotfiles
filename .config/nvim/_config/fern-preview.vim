scriptencoding utf-8

if empty(globpath(&rtp, 'autoload/fern_preview.vim'))
  finish
endif

function! s:fern_preview_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
endfunction

augroup my_fern_preview
  autocmd! *
  autocmd FileType fern call s:fern_preview_settings()
augroup END

