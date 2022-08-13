if exists('did_load_filetypes')
  finish
endif

augroup filetypes
  autocmd BufNewFile,BufRead *.txt      setfiletype markdown
  autocmd BufNewFile,BufRead *.md       setfiletype markdown

  autocmd BufNewFile,BufRead *.less     setfiletype less
  autocmd BufNewFile,BufRead *.sass     setfiletype sass
  autocmd BufNewFile,BufRead *.scss     setfiletype scss
  autocmd BufNewFile,BufRead *.ts       setfiletype typescript
  autocmd BufNewFile,BufRead *.json     setfiletype json
augroup END
