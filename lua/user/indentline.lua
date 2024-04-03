local M = {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "User FileOpened",
}

function M.config()
  local icons = require "user.icons"

  local hooks = require("ibl.hooks")
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "iblIdent", { fg = "#1e222a" })
    vim.api.nvim_set_hl(0, "iblScope", { fg = "#565c64" })
  end)

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
      char = '│',
      smart_indent_cap = true,
      highlight = 'iblIdent'
    },

    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
      highlight = "iblScope"
    },
  }
end

return M
