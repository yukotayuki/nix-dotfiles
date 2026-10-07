-- visual mode の選択範囲の文字数（マルチバイトは 1 文字として数える）
local function selection_count()
  local mode = vim.fn.mode(true):sub(1, 1)
  if not mode:find('[vV\22]') then
    return ''
  end
  local region = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), { type = mode })
  local chars = 0
  for _, line in ipairs(region) do
    chars = chars + vim.fn.strchars(line)
  end
  if #region > 1 then
    return string.format('%dL %dC', #region, chars)
  end
  return string.format('%dC', chars)
end

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        extensions = { 'neo-tree' },
        sections = {
          lualine_y = { selection_count, 'progress' },
        },
      })
    end
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup({
        options = {
          numbers = 'ordinal',
          diagnostics = 'nvim_lsp',
        }
      })
      vim.keymap.set('n', 'tt', '<Cmd>enew<CR>')
      vim.keymap.set('n', 'tn', '<Cmd>BufferLineCycleNext<CR>')
      vim.keymap.set('n', 'tp', '<Cmd>BufferLineCyclePrev<CR>')
      vim.keymap.set('n', 'tc', '<Cmd>bdelete<CR>')
    end
  },
  {
    'b0o/incline.nvim',
    config = function()
      require('incline').setup()
    end
  },
}
