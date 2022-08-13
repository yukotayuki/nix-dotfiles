if $VIMLSP != "vim-lsp"
  finish
endif

if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal completeopt=menu
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
  " inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
  " inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')
" logファイルの取得は常用すると重くなる
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')

" for asyncomplete.vim log
" let g:asyncomplete_log_file = expand('~/asyncomplete.log')

imap <C-x><C-u> <Plug>(asyncomplete_force_refresh)

if !has('nvim')
  let g:lsp_diagnostics_float_cursor = 1
endif
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1
" これがないと勝手に補完されてひどい目に
let g:asyncomplete_enable = 0
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1
let g:asyncomplete_popup_delay = 400
let g:lsp_text_edit_enabled = 0

" let g:lsp_settings = {
"     \ 'eslint-language-server': {
"     \   'allowlist': ['javascript', 'typescript', 'vue'],
"     \ },
"     \}

" let g:lsp_settings_filetype_javascript = ['typescript-language-server', 'eslint-language-server']
" let g:lsp_settings_filetype_typescript = ['typescript-language-server', 'eslint-language-server']
let g:lsp_settings_filetype_typescript = ['deno', 'typescript-language-server']
" let g:lsp_settings_filetype_svelte = ['svelte-language-server']

augroup my_autoSave
  autocmd! *
  autocmd BufWritePre <buffer> LspDocumentFormatSync
  " autocmd BufWritePre *.py  LspDocumentFormatSync
  " autocmd BufWritePre *.nim   :silent !nimpretty --maxLineLen:180 --indent:4 %<CR>:e<CR>:redraw!<CR>
augroup END

" nnoremap <Space>j :w<CR>:silent !nimpretty --maxLineLen:180 --indent:4 %<CR>:e<CR>:redraw!<CR>
