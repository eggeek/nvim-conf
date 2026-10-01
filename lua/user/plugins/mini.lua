local M = {
	'echasnovski/mini.nvim', version = '*'
}

function M.config()
	require("mini.ai").setup()
	require("mini.surround").setup()
	require("mini.pairs").setup()
	require("mini.align").setup() -- ga / gA (with preview) + motion or selection

	local jump2d = require('mini.jump2d')
	local jump_line_start = jump2d.builtin_opts.line_start
	require("mini.jump2d").setup({
		view = { dim = true },
		spotter = jump_line_start.spotter,
		hooks = { after_jump = jump_line_start.hooks.after_jump }
	})
	require("mini.jump").setup()

	-- Colour #rrggbb hex codes, off by default; <leader>z toggles it for the current buffer.
	-- (No hipatterns.setup(): that would turn it on in every buffer.)
	local hipatterns = require("mini.hipatterns")
	local hex = { highlighters = { hex_color = hipatterns.gen_highlighter.hex_color() } }
	vim.keymap.set("n", "<leader>z", function() hipatterns.toggle(0, hex) end, { desc = "Toggle hex colour highlighting" })
end

return M
