local M = {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		{
			"williamboman/mason.nvim",
			event = "User FileOpened",
		},
		"nvim-lua/plenary.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{
			'mrcjkb/rustaceanvim',
			version = '^6', -- Recommended
			lazy = false, -- This plugin is already lazy
		},
		{
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			opts = {},
		}
	},
	event = "User FileOpened",
}

M.servers = {
	"lua_ls",
	"pyright",
	-- "ty",
	-- "ruff",
	"bashls",
	"texlab",
	"clangd",
	"rust_analyzer", -- using rustaceanvim
	"tinymist",
	"taplo",
	"nil_ls"
}

function M.config()
	require("mason").setup {
		PATH = "append",
		ui = {
			border = "rounded",
		},
	}
	require("mason-lspconfig").setup {
		ensure_installed = M.servers,
    automatic_enable = false
	}
	require("mason-tool-installer").setup {
		ensure_installed = {
			"debugpy",
			"codelldb",
		},
	}
end

return M
