local M = {
  'rcarriga/nvim-notify',
  event = "VeryLazy",
}

function M.config()
    require("notify").setup({
      background_colour = "#323641",
      timeout = 1000,
      stages = "fade",
    })
end

return M
