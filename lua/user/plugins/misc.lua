local M = {
	{
		"vale1410/vim-minizinc",
		ft = "zinc"
	},
	{
		"lervag/vimtex",
		lazy = false, -- vimtex must not be lazy-loaded
		init = function() -- runs before vimtex loads, so it sees these settings
			vim.g.vimtex_view_method = "sioyek"
			vim.g.vimtex_log_ignore = {
				"Underfull",
				"Overfull",
				"specifier changed to",
				"Token not allowed in a PDF string",
			}
			vim.g.vimtex_compiler_latexmk = {
				callback = 1,
				continuous = 1,
				executable = "latexmk",
				hooks = {},
				options = { "-shell-escape", "-verbose", "-file-line-error", "-synctex=1", "-interaction=nonstopmode" },
			}
			vim.g.vimtex_complete_enabled = 0
			vim.g.tex_comment_nospell = 1
			vim.g.vimtex_matchparen_enabled = 1
			vim.g.vimtex_quickfix_open_on_warning = 0

			vim.keymap.set({ "n", "x" }, "<localleader>wc", "<cmd>VimtexCountWords<cr>")
			vim.keymap.set("n", "<localleader>lv", "<cmd>VimtexView<cr>")
		end,
	},
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
