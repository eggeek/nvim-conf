local M = {
	'echasnovski/mini.nvim', version = '*'
}

function M.config()
	require("mini.ai").setup()
	require("mini.surround").setup()
	require("mini.pairs").setup()
	require("mini.bracketed").setup()

	local jump2d = require('mini.jump2d')
	local jump_line_start = jump2d.builtin_opts.line_start
	require("mini.jump2d").setup({
		view = { dim = true },
		spotter = jump_line_start.spotter,
		hooks = { after_jump = jump_line_start.hooks.after_jump }
	})
	require("mini.jump").setup()
end

return M
