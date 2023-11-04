local M = {
  "nvim-lualine/lualine.nvim",
}

local components = require "user.lualine_components"

function M.config()
  require("lualine").setup {
    options = {
      theme = require 'user.lualine-theme',
      ignore_focus = { "NvimTree" },
      section_separators = '',
      component_separators = '',
      globalstatus = true,
      icons_enabled = true,
      disabled_filetypes = { "alpha" },
    },
    sections = {
      lualine_a = { components.mode },
      lualine_b = { components.branch },
      lualine_c = {
        {
          "navic",
          color_correction = 'static',
          navic_opts = components.navic_opts,
          padding = { left = 1, right = 0 }
        }
      },
      lualine_x = {
        components.diagnostics,
        components.lsp,
        components.spaces,
        components.python_env,
      },
      lualine_y = { components.filetype, components.location },
      lualine_z = { "progress" },
    },
    winbar = {
      lualine_c = {
        {
          components.winbar_fname,
          color = "@text.strong"
        }
      },
    },
    inactive_winbar = {
      lualine_c = {
        {
          components.winbar_fname,
          color = {fg = 'grey', bg = 'none', gui='bold'}
        }
      }
    }
  }
end

return M
