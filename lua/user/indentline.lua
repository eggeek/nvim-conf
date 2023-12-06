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
      smart_indent_cap = true
    },

    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
      -- highlight = { "Function", "Label" },
      highlight = "@comment"
    },
  }
end

return M
