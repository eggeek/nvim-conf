vim.o.guifont = "CaskaydiaCove Nerd Font:h12"
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_scroll_animation_length = 0

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(1.25)
end)
vim.keymap.set("n", "<C-->", function()
  change_scale_factor(1/1.25)
end)
