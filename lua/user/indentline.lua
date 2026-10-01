return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "User FileOpened",
  config = function()
    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "iblIdent", { fg = "#1e222a" })
      vim.api.nvim_set_hl(0, "iblScope", { fg = "#565c64" })
    end)

    require("ibl").setup {
      -- added to ibl's own exclude lists (help, man, terminal, nofile, ... are already there)
      exclude = { filetypes = { "lazy", "text" } },
      indent = { char = "│", highlight = "iblIdent" },
      scope = { show_start = false, show_end = false, highlight = "iblScope" },
    }
  end,
}
