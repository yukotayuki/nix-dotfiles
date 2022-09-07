scriptencoding utf-8

if empty(globpath(&rtp, 'autoload/fern.vim'))
  finish
endif

function! s:fern_init() abort
  " nerdfontの使用
  let g:fern#renderer="nerdfont"
  " fernを開いた時のカーソルを隠す
  let g:fern#smart_cursor = has('nvim-0.5.0') ? 'hide' : 'stick'
  " 隠しファイルを表示
  let g:fern#default_hidden = 1
endfunction

function! s:fern_local_init() abort
  nmap <buffer>
        \ <Plug>(fern-my-enter-and-tcd)
        \ <Plug>(fern-action-enter)<Plug>(fern-wait)<Plug>(fern-action-tcd:root)
  nmap <buffer>
        \ <Plug>(fern-my-leave-and-tcd)
        \ <Plug>(fern-action-leave)<Plug>(fern-wait)<Plug>(fern-action-tcd:root)
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-or-enter-and-tcd)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open)",
        \   "\<Plug>(fern-my-enter-and-tcd)",
        \ )
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-or-enter)
        \ fern#smart#drawer(
        \   "\<Plug>(fern-my-open-or-enter-and-tcd)",
        \   "\<Plug>(fern-action-open-or-enter)",
        \ )
  nmap <buffer><expr>
        \ <Plug>(fern-my-leave)
        \ fern#smart#drawer(
        \   "\<Plug>(fern-my-leave-and-tcd)",
        \   "\<Plug>(fern-action-leave)",
        \ )
  nmap <buffer><nowait> <C-m> <Return>
  nmap <buffer><nowait> <C-h> <Backspace>
  nmap <buffer><nowait> <Return>    <Plug>(fern-my-open-or-enter)
  nmap <buffer><nowait> <Backspace> <Plug>(fern-my-leave)
  nmap <buffer><nowait> T <Plug>(fern-action-terminal)
  nnoremap <buffer><nowait> ~ :<C-u>Fern ~<CR>
endfunction

" fern toggle
nnoremap ,f :<C-u>Fern .<CR>
" nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=40<CR>
" nnoremap <Space>v :<C-u>Fern $HOME/.vim<CR>

augroup my_fern
  autocmd! *
  autocmd VimEnter * call s:fern_init()
  autocmd FileType fern call s:fern_local_init()
augroup END

