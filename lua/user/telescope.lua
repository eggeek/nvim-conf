local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true } },
  lazy = true,
  cmd = "Telescope",
}

function M.config()
  local icons = require "user.icons"
  local actions = require "telescope.actions"
  local action_layout = require("telescope.actions.layout")
  require("telescope").setup {
    defaults = {
      prompt_prefix = icons.ui.Search .. " : ",
      selection_caret = icons.ui.Forward .. " ",
      -- entry_prefix = "   ",
      initial_mode = "insert",
      selection_strategy = "reset",
      -- path_display = { "smart" },
      color_devicons = true,
      set_env = { ["COLORTERM"] = "truecolor" },
      sorting_strategy = nil,
      layout_strategy = nil,
      layout_config = {},
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },

      mappings = {
        i = {
          ["<C-u>"] = false, -- use <C-u> to clear prompt
          ["<C-e>"] = actions.preview_scrolling_up,
          ["<C-y>"] = actions.preview_scrolling_down,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-n>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-p>"] = actions.move_selection_previous,
          ["<C-c>"] = actions.close,
          ["<C-h>"] = actions.cycle_history_next,
          ["<C-l>"] = actions.cycle_history_prev,
          ["<C-q>"] = function(...)
            actions.smart_send_to_qflist(...)
            actions.open_qflist(...)
          end,
          ["<CR>"] = actions.select_default,
          ["<M-p>"] = action_layout.toggle_preview,
        },
        n = {
          ["<esc>"] = actions.close,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["q"] = actions.close,
          ["p"] = action_layout.toggle_preview,
        },
      },
    },
    pickers = {
      live_grep = {
        theme = "dropdown",
      },

      grep_string = {
        theme = "dropdown",
      },

      find_files = {
        theme = "dropdown",
        previewer = false,
      },

      buffers = {
        theme = "dropdown",
        previewer = true,
        initial_mode = "insert",
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
      },

      planets = {
        show_pluto = false,
        show_moon = false,
      },

      colorscheme = {
        enable_preview = true,
      },

      lsp_references = {
        theme = "dropdown",
        initial_mode = "normal",
      },

      lsp_definitions = {
        theme = "dropdown",
        initial_mode = "normal",
      },

      lsp_declarations = {
        theme = "dropdown",
        initial_mode = "normal",
      },

      lsp_implementations = {
        theme = "dropdown",
        initial_mode = "normal",
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      },
    },
  }
end

return M
