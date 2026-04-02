return {
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        current_line_blame = true,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          map('n', '<Space>hs', gs.stage_hunk)
          map('n', '<Space>hr', gs.reset_hunk)
          map('v', '<Space>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
          map('v', '<Space>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
          map('n', '<Space>hS', gs.stage_buffer)
          map('n', '<Space>hu', gs.undo_stage_hunk)
          map('n', '<Space>hR', gs.reset_buffer)
          map('n', '<Space>hp', gs.preview_hunk)
          map('n', '<Space>hb', function() gs.blame_line({ full = true }) end)
          map('n', '<Space>hd', gs.diffthis)
          map('n', '<Space>hD', function() gs.diffthis('~') end)
        end
      })
    end
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<Space>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diffview: Open' },
      { '<Space>gD', ':DiffviewOpen ', desc = 'Diffview: Open (branch)' },
      { '<Space>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diffview: File history' },
      { '<Space>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Diffview: All history' },
      { '<Space>gq', '<cmd>DiffviewClose<cr>', desc = 'Diffview: Close' },
    },
    config = function()
      require('diffview').setup({
        view = {
          merge_tool = {
            layout = 'diff3_mixed',
          },
        },
        file_panel = {
          win_config = {
            position = 'left',
            width = 35,
          },
          listing_style = 'tree',
          tree_options = {
            flatten_dirs = true,
            folder_statuses = 'only_folded',
          },
        },
        -- ファイルパネルのフォールドをデフォルトで開いた状態にする
        hooks = {
          diff_buf_win_enter = function()
            vim.opt_local.foldenable = false
          end,
          -- 最初のファイルを自動で開く
          view_opened = function()
            local actions = require('diffview.actions')
            actions.goto_file_edit()
          end,
        },
      })
      -- 背景をベタ塗りではなく透過的に
      vim.api.nvim_set_hl(0, 'DiffviewDiffAddAsDelete', { bg = 'none', fg = '#bf616a', strikethrough = true })
      vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', { bg = 'none', fg = '#4c566a' })
      vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#3b4252', fg = 'none' })
      vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#3b4252', fg = 'none' })
      vim.api.nvim_set_hl(0, 'DiffDelete', { bg = 'none', fg = '#4c566a' })
      vim.api.nvim_set_hl(0, 'DiffText', { bg = '#434c5e', fg = 'none' })
    end,
  },
}
