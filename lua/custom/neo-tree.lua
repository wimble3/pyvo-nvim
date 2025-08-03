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
  },
  init = function()
    -- Open Neo-tree when starting Neovim
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        -- Only open if no file was specified
        if vim.fn.argc() == 0 then
          vim.cmd('Neotree show')
        end
      end,
    })
  end,
  config = function()
    -- Custom function to open in new tab and keep Neo-tree visible
    local function open_in_tab(state)
      local node = state.tree:get_node()
      
      -- Save current window
      local current_win = vim.api.nvim_get_current_win()
      
      -- Open in new tab
      vim.cmd('tabnew')
      vim.cmd('edit ' .. vim.fn.fnameescape(node.path))
      
      -- Go back to Neo-tree
      vim.cmd('tabprevious')
    end

    require('neo-tree').setup({
      close_if_last_window = false,  -- Keep Neo-tree open even if it's the last window
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
        width = 30,
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
          enabled = false,  -- Disable auto-following the current file
        },
        filtered_items = {
          visible = true,           -- Show filtered items
          hide_dotfiles = false,    -- Show dotfiles
          hide_gitignored = true,   -- Hide gitignored files
        },
        use_libuv_file_watcher = true, -- Better file watching
      },
      event_handlers = {
        {
          event = 'file_opened',
          handler = function()
            -- Don't close Neo-tree when opening a file
            vim.cmd('Neotree show')
          end,
        },
      },
    })

    -- Show current file in Neo-tree on first open
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = '*',
      once = true,  -- Run only once
      callback = function()
        -- Don't run for Neo-tree buffers and empty buffers
        if vim.bo.filetype ~= 'neo-tree' and vim.fn.expand('%') ~= '' then
          vim.defer_fn(function()
            vim.cmd('Neotree reveal')
          end, 100)
        end
      end,
    })
  end,
}
