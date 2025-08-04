return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  keys = {
    { '<leader>e', ':Neotree toggle<CR>', desc = 'Toggle Neo-tree' },
    { '<leader>t', ':tabnew New tab<CR>', desc = '[T]abnew' },

  },
  init = function()
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        if vim.fn.argc() == 0 then
          vim.cmd('Neotree show')
        end
      end,
    })
  end,
  config = function()
    local function open_in_tab(state)
      local node = state.tree:get_node()

      local current_win = vim.api.nvim_get_current_win()

      vim.cmd('tabnew')
      vim.cmd('edit ' .. vim.fn.fnameescape(node.path))
      vim.cmd('tabprevious')
    end

    require('neo-tree').setup({
      close_if_last_window = false,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
      },
      window = {
        position = 'left',
        width = 40,
        auto_expand_width = false,
        preserve_window_proportions = false,
        mappings = {
          ['<cr>'] = 'open',
          ['t'] = 'open_tabnew',
          ['s'] = 'open_vsplit',
          ['i'] = 'open_split',
          ['H'] = 'toggle_hidden',
          ['/'] = 'fuzzy_finder',
          ['#'] = 'fuzzy_finder_directory',
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = false,
        },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
        use_libuv_file_watcher = true,
      },
      event_handlers = {
        {
          event = 'file_opened',
          handler = function()
            vim.cmd('Neotree show')
          end,
        },
      },
    })

    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = '*',
      once = true,
      callback = function()
        if vim.bo.filetype ~= 'neo-tree' and vim.fn.expand('%') ~= '' then
          vim.defer_fn(function()
            vim.cmd('Neotree reveal')
          end, 100)
        end
      end,
    })
  end,
}
