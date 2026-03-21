vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { '*.txt', '*.md' },
  command = 'setlocal filetype=markdown'
})
