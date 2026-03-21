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
    config = function()
      require('window-picker').setup()
      require('neo-tree').setup({
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
