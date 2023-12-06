local M = {
  'navarasu/onedark.nvim',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
}

function M.config()
  require 'onedark'.setup {
    transparent = false,
    style = 'cool',
    -- toggle theme style ---
    toggle_style_key = "<leader>ts",
    toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' },
    code_style = {
      -- functions = 'bold'
    },
    colors = {
      -- bg0 = '#1e222a'
      -- bg0 = '#1a1b21'
      bg0 = '#0d1117',
      -- bg0 = '#010409'
    }
  }
  vim.cmd.colorscheme "onedark"
end

return M
