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
      lualine_a = {
        components.mode,
        {
          function() return "DEBUG" end,
          cond = function() return package.loaded["user.dap.core"] and require("user.dap.core").active() end,
        },
      },
      lualine_b = { components.branch },
      lualine_c = {
        {
          "navic",
          color_correction = 'dynamic',
          navic_opts = components.navic_opts,
          padding = { left = 1, right = 0 }
        },
        { -- LSP signature while typing arguments (lsp_signature, see lspconfig.lua)
          function()
            local sig = require("lsp_signature").status_line(math.floor(vim.o.columns / 2))
            local text = sig.hint ~= "" and (sig.label .. "  [" .. sig.hint .. "]") or sig.label
            return (text:gsub("%%", "%%%%")) -- % is special in statuslines
          end,
          cond = function()
            return package.loaded.lsp_signature ~= nil and vim.fn.mode():sub(1, 1) == "i"
          end,
        },
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
          color = "@markup.strong"
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
