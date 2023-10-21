local M = {
  'navarasu/onedark.nvim',
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
}

function M.config()
  require 'onedark'.setup {
    transparent = true,
    style = 'darker',
    -- toggle theme style ---
    toggle_style_key = "<leader>ts",                                                   -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
    toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }, -- List of styles to toggle between
    code_style = {
      functions = 'bold'
    }
  }
  vim.cmd.colorscheme "onedark"
end

return M
