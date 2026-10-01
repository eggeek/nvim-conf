local M = {
	"hrsh7th/nvim-cmp",
	dependencies = {
		{
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
	},
	event = "InsertEnter",
}

function M.config()
	-- require "user.cmp-core".config()
	require("user.cmp-core").setup()

	-- config LuaSnip
	require("luasnip").setup({
		region_check_events = "CursorMoved", -- exit session when cursor leaves the snippet region
		delete_check_events = "TextChanged", -- drop nodes whose text was deleted
	})
	require("luasnip.loaders.from_lua").lazy_load()
	-- require("luasnip.loaders.from_vscode").lazy_load { }
	-- require("luasnip.loaders.from_snipmate").lazy_load()
end

return M
