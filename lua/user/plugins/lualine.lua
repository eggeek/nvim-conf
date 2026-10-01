local M = {
  "nvim-lualine/lualine.nvim",
}

local components = require "user.lualine_components"

-- True while typing call arguments: insert mode and lsp_signature holds a signature.
-- lsp_signature clears it on InsertLeave or when the server reports no signature.
local function signature_active()
  return package.loaded.lsp_signature ~= nil
    and vim.fn.mode():sub(1, 1) == "i"
    and require("lsp_signature").status_line().label ~= ""
end

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
      -- same slot: navic breadcrumbs, replaced by the LSP signature while typing arguments
      lualine_c = {
        {
          "navic",
          color_correction = 'dynamic',
          navic_opts = components.navic_opts,
          padding = { left = 1, right = 0 },
          cond = function() return not signature_active() end,
        },
        { -- LSP signature (lsp_signature, see lspconfig.lua)
          function()
            local sig = require("lsp_signature").status_line(math.floor(vim.o.columns / 2))
            local text = sig.hint ~= "" and (sig.label .. "  [" .. sig.hint .. "]") or sig.label
            return (text:gsub("%%", "%%%%")) -- % is special in statuslines
          end,
          cond = signature_active,
          -- colours from LualineSignature (onedark.lua); an unset bg falls back to the statusline's
          color = function()
            local hl = vim.api.nvim_get_hl(0, { name = "LualineSignature", link = false })
            local hex = function(n) return n and string.format("#%06x", n) end
            return { fg = hex(hl.fg), bg = hex(hl.bg), gui = hl.bold and "bold" or nil }
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
