let g:ale_linters = {}
let g:ale_linters['javascript'] = ['eslint']
let g:ale_linters['python'] = ['flake8', 'mypy']
let g:ale_lint_delay = 200
let g:ale_lint_on_enter = 1
let g:ale_linters_on_text_changed = 1
let g:ale_lint_on_text_changed = 'always'
let g:ale_fixers = {}
let g:ale_fixers['python'] = ['isort', 'black']
let g:ale_fixers['javascript'] = 'eslint'
let g:ale_fixers['vue'] = 'eslint'
let g:ale_fixers['nim'] = 'nimpretty'
" let g:ale_fixers = {'nim': ['nimpretty'],}
let g:ale_python_flake8_options = '--ignore=E712 --max-line-length=80'
let g:ale_python_black_options = '--line-length=80'
let g:ale_nim_nimpretty_options = '--maxLineLen:80 --indent:2'
" let g:ale_nim_nimpretty_options = '--maxLineLen:180 --indent:4'
let g:ale_fix_on_save = 1
" Set this in your vimrc file to disabling highlighting
" let g:ale_set_highlights = 0
