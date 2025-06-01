local M = {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		{
			"williamboman/mason.nvim",
			event = "User FileOpened",
			lazy = true,
		},
		"nvim-lua/plenary.nvim",
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
	lazy = true,
	event = "User FileOpened",
}

M.servers = {
	"lua_ls",
	-- "cssls",
	-- "html",
	"pyright",
	"ruff",
	-- "pylyzer",
	"bashls",
	-- "jsonls",
	-- "yamlls",
	"texlab",
	"clangd",
	-- "jdtls",
	"rust_analyzer", -- using rustaceanvim
	-- "tailwindcss",
	"tinymist",
	"cmake",
	"julials",
	"ts_ls"
}

-- M.linters = {
--   -- "mypy",
-- }
--
-- M.installed_list = require "user.utils".merge_tbls(
--   M.servers, M.linters)

function M.config()
	require("mason").setup {
		ui = {
			border = "rounded",
		},
	}
	require("mason-lspconfig").setup {
		ensure_installed = M.servers,
    automatic_enable = false
	}
end

return M
