return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      's1n7ax/nvim-window-picker',
    },
    event = { 'BufEnter' },
    config = function()
      -- 引数なしで nvim を起動した場合にカレントディレクトリで neo-tree を自動オープンする。
      -- ファイルを直接開く場合（nvim file.lua）は開かない。
      if vim.fn.argc() == 0 and vim.fn.isdirectory(vim.fn.getcwd()) == 1 then
        vim.cmd('Neotree show focus float')
      end

      require('window-picker').setup()
      require('neo-tree').setup({
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
          },
        },
        git_status_async = true,
        git_status = {
          symbols = {
            added     = '✚',
            modified  = '',
            deleted   = '✖',
            renamed   = '󰁕',
            untracked = '',
            ignored   = '',
            unstaged  = '󰄱',
            staged    = '',
            conflict  = '',
          }
        },
        window = {
          mappings = {
            ['tf'] = { 'telescope_find', nowait = true },
            ['tg'] = { 'telescope_grep', nowait = true },
          },
        },
        commands = {
          telescope_find = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            require('telescope.builtin').find_files({ cwd = path })
          end,
          telescope_grep = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            require('telescope.builtin').live_grep({ cwd = path })
          end,
        },
      })
      vim.keymap.set('n', ',f', '<Cmd>Neotree float toggle<CR>')
    end
  }
}
