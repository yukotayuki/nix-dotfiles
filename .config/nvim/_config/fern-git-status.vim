if empty(globpath(&rtp, 'autoload/fern_git_status.vim'))
  finish
endif

function! s:fern_git_status_settings() abort
  let g:fern_git_status#disable_ignored = 1
  let g:fern_git_status#disable_untracked = 1
  let g:fern_git_status#disable_submodules = 1
endfunction

augroup my_fern_git_status
  autocmd! *
  autocmd FileType fern call s:fern_git_status_settings()
augroup END

