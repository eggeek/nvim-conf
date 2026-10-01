return {
  "SmiteshP/nvim-navic",
  event = "User FileOpened",
  opts = function()
    local icons = require "user.icons"
    return {
      icons = icons.kind,
      highlight = true,
      click = true,
      separator = " " .. icons.ui.ChevronRight .. " ",
      depth_limit = 0,
      depth_limit_indicator = "..",
    }
  end,
}
