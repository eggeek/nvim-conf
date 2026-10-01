return {
  "navarasu/onedark.nvim",
  lazy = false, -- main colorscheme: load during startup
  config = function()
    require("onedark").setup {
      transparent = true,
      style = "cool",
      toggle_style_key = "<leader>ts",
      toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
      colors = {
        bg0 = "#0d1117",
        -- own colours, used as "$name" in highlights below
        float_border = "#e06c75",
        selection = "#264F78",
        cmp_abbr = "#7c838f",
        cmp_match = "#E8AB53",
        cmp_ghost = "#2D333C",
        tab_fg = "#535965",
        tab_sel_fg = "#75BEFF",
        tab_bg = "#22262e",
      },
      -- Re-applied whenever onedark loads, so they survive <leader>ts style switches.
      -- Only the given attributes change; the rest come from the theme.
      highlights = {
        Visual = { bg = "$selection" },
        NormalFloat = { bg = "none" },
        FloatBorder = { fg = "$float_border", bg = "none" },
        TabLine = { fg = "$tab_fg", bg = "$tab_bg" },
        TabLineSel = { fg = "$tab_sel_fg", bg = "$bg0" },
        TabLineFill = { bg = "$tab_bg" },
        TelescopeMatching = { fg = "#73C991", fmt = "bold" },
        DapStoppedLine = { bg = "#433d28" },
        LspSignatureActiveParameter = { bg = "$selection" },

        -- completion menu: nvim-cmp groups and their blink.cmp equivalents
        CmpItemAbbr = { fg = "$cmp_abbr" },
        CmpItemAbbrMatch = { fg = "$cmp_match" },
        CmpItemAbbrMatchFuzzy = { fg = "$cmp_match" },
        CmpGhostText = { fg = "$cmp_ghost" },
        BlinkCmpLabel = { fg = "$cmp_abbr" },
        BlinkCmpLabelMatch = { fg = "$cmp_match" },
        BlinkCmpGhostText = { fg = "$cmp_ghost" },
        BlinkCmpSource = { fg = "$light_grey" }, -- as CmpItemMenu
        -- window style of nvim-cmp's bordered(): Normal background, FloatBorder, Visual selection
        BlinkCmpMenu = { fg = "$fg" },
        BlinkCmpMenuBorder = { fg = "$float_border" },
        BlinkCmpMenuSelection = { bg = "$selection" },
        BlinkCmpDoc = { fg = "$fg" },
        BlinkCmpDocBorder = { fg = "$float_border" },
      },
    }
    vim.cmd.colorscheme "onedark"
  end,
}
