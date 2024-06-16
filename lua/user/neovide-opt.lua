vim.o.guifont = "CaskaydiaCove Nerd Font:h11"
vim.o.clipboard = 'unnamedplus'
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

-- https://github.com/neovide/neovide/issues/113
vim.keymap.set('v', '<sc-c>', '"+y',             {noremap = true}) -- Copy
vim.keymap.set('c', '<sc-v>', '<C-R>+',          {noremap = true}) -- Paste command mode
-- vim.keymap.set('i', '<sc-v>', '<ESC>l"+Pli',     {noremap = true}) -- Paste insert mode
vim.keymap.set('i', '<sc-v>', '<C-R>+',     {noremap = true}) -- Paste insert mode
vim.keymap.set('t', '<sc-v>', '<C-\\><C-n>"+Pi', {noremap = true}) -- Paste terminal mode

