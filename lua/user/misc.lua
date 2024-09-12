local M = {
	{
		"vale1410/vim-minizinc",
		ft = "zinc"
	},
	'lervag/vimtex',
	{
		'norcalli/nvim-colorizer.lua',
		event = 'VeryLazy',
	},
	-- {
	-- 	"andymass/vim-matchup",
	-- 	config = function()
	-- 		vim.g.matchup_matchpref = { html = { nolists = 1 } }
	-- 		vim.g.matchup_matchparen_offscreen = { method = "popup", scrolloff = 1 }
	-- 	end
	-- },
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require 'treesitter-context'.setup {
				enable = true,      -- Enable this plugin (Can be enabled/disabled later via commands)
				max_lines = 0,      -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to show for a single context
				trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = 'cursor',    -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			}
		end
	},
	{ -- lsp progress
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		opts = {},
	},
	{
		'junegunn/vim-easy-align',
		config = function()
			vim.cmd [[
        " Start interactive EasyAlign in visual mode (e.g. vipga)
        xmap ga <Plug>(EasyAlign)
        " Start interactive EasyAlign for a motion/text object (e.g. gaip)
        nmap ga <Plug>(EasyAlign)
      ]]
		end
	},
	-- {
	--   "ggandor/leap.nvim",
	--   event = "VeryLazy",
	--   dependencies = {
	--     "tpope/vim-repeat"
	--   },
	--   config = function ()
	--     require('leap').create_default_mappings()
	--   end
	-- },
	{ -- predefined stubs for pyright
		"microsoft/python-type-stubs",
		cond = false
	}
}
return M
