local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
  cmd = "Telescope",
  keys = {
    { "<C-p>", "<cmd>Telescope find_files previewer=false<cr>", desc = "Find files" },
    { "<leader>bf", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>/", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },
    { "<leader>;", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume last picker" },
    { "<leader>mp", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    { "<M-x>", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<M-o>", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
  },
}

function M.config()
  local icons = require "user.icons"
  local actions = require "telescope.actions"
  local action_layout = require "telescope.actions.layout"
  require("telescope").setup {
    defaults = {
      prompt_prefix = icons.ui.Search .. " : ",
      selection_caret = icons.ui.Forward .. " ",
      set_env = { ["COLORTERM"] = "truecolor" },
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
      live_grep = { theme = "dropdown" },
      grep_string = { theme = "dropdown" },
      find_files = { theme = "dropdown", previewer = false },
      buffers = {
        theme = "dropdown",
        previewer = true,
        mappings = {
          i = { ["<C-d>"] = actions.delete_buffer },
          n = { ["dd"] = actions.delete_buffer },
        },
      },
      colorscheme = { enable_preview = true },
      lsp_references = { theme = "dropdown", initial_mode = "normal" },
      lsp_definitions = { theme = "dropdown", initial_mode = "normal" },
      lsp_declarations = { theme = "dropdown", initial_mode = "normal" },
      lsp_implementations = { theme = "dropdown", initial_mode = "normal" },
    },
  }
  require("telescope").load_extension "fzf"
end

return M
