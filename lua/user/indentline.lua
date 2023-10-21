local M = {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "User FileOpened",
}

function M.config()
  local icons = require "user.icons"

  require("ibl").setup {
    enabled = true,
    exclude = {
      buftypes = { "terminal", "nofile" },
      filetypes = {
        "help",
        "startify",
        "dashboard",
        "lazy",
        "neogitstatus",
        "NvimTree",
        "Trouble",
        "text",

      }
    },
    indent = {
      char = icons.ui.LineLeft,
    },
    -- char = icons.ui.LineLeft,
    -- show_trailing_blankline_indent = false,
    -- show_first_indent_level = true,
    -- use_treesitter = true,
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
      highlight = "@comment"
    },
  }
end

return M
