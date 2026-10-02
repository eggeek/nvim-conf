if vim.g.neovide then
	require "user.neovide-opt"
end

require "user.options"
require "user.keymaps"
require "user.lazy" -- bootstrap lazy.nvim

-- Plugin list: each entry loads lua/user/plugins/<name>.lua (gf on the name opens it).
-- Turn one off with `enabled = false`.
-- (Order here doesn't affect load order; use `priority`/`dependencies` in a spec for that.)

require("lazy").setup {
	spec = {
		-- ui
		{ import = "user.plugins.onedark" },
		{ import = "user.plugins.devicons" },
		{ import = "user.plugins.treesitter" },
		{ import = "user.plugins.lualine" },
		{ import = "user.plugins.gitsigns" },
		{ import = "user.plugins.indentline" },

		-- lsp
		{ import = "user.plugins.mason" },
		{ import = "user.plugins.lspconfig" },
		{ import = "user.plugins.linter", enabled = false },
		{ import = "user.plugins.navic" },
		{ import = "user.plugins.illuminate" },
		{ import = "user.plugins.debugger" },

		-- search
		{ import = "user.plugins.telescope" },
		{ import = "user.plugins.project" },
		{ import = "user.plugins.bqf" },
		{ import = "user.plugins.fzf" },

		-- editing
		{ import = "user.plugins.blink" },
		{ import = "user.plugins.cmp", enabled = false }, -- previous completion setup (nvim-cmp)
		{ import = "user.plugins.autopairs", enabled = false },
		{ import = "user.plugins.formatter" },

		-- ai
		{ import = "user.plugins.copilot" },
		{ import = "user.plugins.opencode", enabled = false },
		{ import = "user.plugins.avante", enabled = false },

		-- enhancement
		{ import = "user.plugins.nvim-tmux" },
		{ import = "user.plugins.notify" },
		{ import = "user.plugins.mini" },
		{ import = "user.plugins.surround", enabled = false },

		-- note taking
		{ import = "user.plugins.notetaking" },

		-- misc
		{ import = "user.plugins.misc" },
	},
	ui = { border = "rounded" },
	change_detection = { notify = false },
}

-- Also loaded automatically:
--   plugin/tabline.lua     tab line
--   after/plugin/*.lua     autocmds
--   after/lsp/*.lua        per-server LSP settings
