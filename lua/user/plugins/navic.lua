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
      -- texlab copies `\mbox {VIII-A}` section numbers from .aux files as "\mbox  VIII-A".
      -- SHORTCUT NOTE: strips only a leading \mbox in TeX; remove once texlab unwraps it (base-db/src/semantics/auxiliary.rs).
      format_text = function(text)
        if vim.bo.filetype ~= "tex" then return text end
        return (text:gsub("^\\mbox%s+", ""))
      end,
    }
  end,
}
