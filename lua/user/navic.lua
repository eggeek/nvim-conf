local M = {
  "SmiteshP/nvim-navic",
  event = "User FileOpened",
}

function M.config()
  local icons = require "user.icons"
  require("nvim-navic").setup {
    icons = icons.kind,
    highlight = true,
    click = true,
    separator = " " .. icons.ui.ChevronRight .. " ",
    depth_limit = 0,
    depth_limit_indicator = "..",
  }
end

return M
