local M = {
	'echasnovski/mini.nvim', version = '*'
}

function M.config()
	require ("mini.ai").setup()
	require ("mini.surround").setup()
	require ("mini.pairs").setup()
	require ("mini.bracketed").setup()
	require ("mini.jump2d").setup()
	require ("mini.jump").setup()
end

return M
