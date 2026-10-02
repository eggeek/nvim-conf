return {
  "navarasu/onedark.nvim",
  lazy = false, -- main colorscheme: load during startup, before other plugins
  priority = 1000,
  config = function()
    require("onedark").setup {
      transparent = true,
      style = "cool",
      toggle_style_key = "<leader>ts",
      toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
      colors = {
        bg0 = "#0d1117",
      },
      -- Re-applied whenever onedark loads, so they survive <leader>ts style switches.
      -- Only the given attributes change; the rest come from the theme.
      highlights = {
        Visual = { bg = "#264F78" },
        NormalFloat = { bg = "none" },
        FloatBorder = { fg = "#e06c75", bg = "none" },
        TabLine = { fg = "#535965", bg = "#2D333C" },
        TabLineSel = { fg = "#75BEFF", bg = "#22262e", fmt = "bold" },
        TabLineFill = { bg = "#2D333C" },
        TelescopeMatching = { fg = "#73C991", fmt = "bold" },
        DapStoppedLine = { bg = "#433d28" },
        LspSignatureActiveParameter = { bg = "#264F78" },
        -- signature text in the statusline (lualine.lua); bg "none" = statusline's own background
        LualineSignature = { fg = "$yellow", bg = "none", fmt = "none" },

        -- completion menu: nvim-cmp groups and their blink.cmp equivalents
        CmpItemAbbr = { fg = "#7c838f" },
        CmpItemAbbrMatch = { fg = "#E8AB53" },
        CmpItemAbbrMatchFuzzy = { fg = "#E8AB53" },
        CmpGhostText = { fg = "#2D333C" },
        BlinkCmpLabel = { fg = "#7c838f" },
        BlinkCmpLabelMatch = { fg = "#E8AB53" },
        BlinkCmpGhostText = { fg = "#2D333C" },
        BlinkCmpSource = { fg = "$light_grey" }, -- as CmpItemMenu
        -- window style of nvim-cmp's bordered(): Normal background, FloatBorder, Visual selection
        BlinkCmpMenu = { fg = "$fg" },
        BlinkCmpMenuBorder = { fg = "#e06c75" },
        BlinkCmpMenuSelection = { bg = "#264F78" },
        BlinkCmpDoc = { fg = "$fg" },
        BlinkCmpDocBorder = { fg = "#e06c75" },
      },
    }
    vim.cmd.colorscheme "onedark"
  end,
}
