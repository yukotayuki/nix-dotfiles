-- .txt をメモとして Markdown で開く。help のファイルも .txt なので、help のバッファは除く。
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = '*.txt',
  callback = function()
    if vim.bo.buftype ~= 'help' then
      vim.bo.filetype = 'markdown'
    end
  end,
})
