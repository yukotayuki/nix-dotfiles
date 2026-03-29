return {
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    opts = {
      filter_rules = {
        include_current = false,
        autoselect_one = true,
        bo = {
          filetype = { 'neo-tree', 'neo-tree-popup', 'notify', 'fidget' },
          buftype = { 'terminal', 'quickfix' }
        }
      },
    },
  },
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
    config = function(_, opts)
      require('neo-tree').setup(opts)
      -- 引数なしで nvim を起動した場合にカレントディレクトリで neo-tree を自動オープンする。
      -- ファイルを直接開く場合（nvim file.lua）は開かない。
      if vim.fn.argc() == 0 and vim.fn.getcwd() then
        vim.cmd('Neotree show focus float')
      end
    end,
    opts = function()
      local function getTelescopeOpts(state, path)
        return {
          cwd = path,
          search_dirs = { path },
          attach_mappings = function(prompt_bufnr, map)
            local actions = require('telescope.actions')
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local action_state = require('telescope.actions.state')
              local selection = action_state.get_selected_entry()
              local filename = selection.filename
              if (filename == nil) then
                filename = selection[1]
              end
              require('neo-tree.sources.filesystem').navigate(state, state.path, filename)
            end)
            return true
          end
        }
      end
      return {
        default_component_configs = {
          git_status = {
            symbols = {
              added     = '✚',
              deleted   = '✖',
              modified  = '',
              renamed   = '󰁕',
              untracked = '',
              ignored   = '',
              unstaged  = '󰄱',
              staged    = '',
              conflict  = '',
            }
          }
        },
        filesystem = {
          window = {
            mappings = {
              ['tf'] = 'telescope_find',
              ['tg'] = 'telescope_grep',
            },
          },
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
          },
        },
        commands = {
          telescope_find = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            require('telescope.builtin').find_files(getTelescopeOpts(state, path))
          end,
          telescope_grep = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            require('telescope.builtin').live_grep(getTelescopeOpts(state, path))
          end,
        },
      }
    end,
    keys = {
      {
        ',f',
        ':Neotree reveal position=float toggle<CR>',
        silent = true,
      },
    },
  }
}
