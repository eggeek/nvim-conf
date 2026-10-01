local M = {
	{
		"vale1410/vim-minizinc",
		ft = "zinc"
	},
	'lervag/vimtex',
	-- {
	-- 	"andymass/vim-matchup",
	-- 	config = function()
	-- 		vim.g.matchup_matchpref = { html = { nolists = 1 } }
	-- 		vim.g.matchup_matchparen_offscreen = { method = "popup", scrolloff = 1 }
	-- 	end
	-- },
	{ -- lsp progress
		"j-hui/fidget.nvim",
		version = "*", -- latest release tag
		event = "LspAttach",
		opts = {},
	},
	{ -- predefined stubs for pyright
		"microsoft/python-type-stubs",
		cond = false
	}
}
return M
