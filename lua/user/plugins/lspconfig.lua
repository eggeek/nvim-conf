local M = {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason-lspconfig.nvim",
		"ray-x/lsp_signature.nvim",
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
}

-- Built-in LSP keys already cover K (hover), grr/gri/grn/gra/grt and gO.
-- These add the ones Neovim has no default for.
local function lsp_keymaps(bufnr)
	local opts = { buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
	-- No automatic window or hint: the signature shows in the statusline (lualine.lua).
	-- Insert mode: <M-x> toggles the signature window, <M-n> cycles overloads.
	require("lsp_signature").on_attach({
		floating_window = false,
		hint_enable = false,
		doc_line = 0,
		toggle_key = "<M-x>",
		select_signature_key = "<M-n>",
	}, bufnr)
	if client.server_capabilities.documentSymbolProvider then
		require("nvim-navic").attach(client, bufnr)
	end
end

local function disable_dynamic_file_watchers(capabilities)
	capabilities.workspace = capabilities.workspace or {}
	capabilities.workspace.didChangeWatchedFiles =
		vim.tbl_deep_extend("force", capabilities.workspace.didChangeWatchedFiles or {}, {
			dynamicRegistration = false,
		})
	return capabilities
end

-- Completion capabilities come from whichever completion plugin is enabled in init.lua
function M.common_capabilities()
	local blink_ok, blink = pcall(require, "blink.cmp")
	if blink_ok then
		return disable_dynamic_file_watchers(blink.get_lsp_capabilities())
	end

	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_ok then
		return disable_dynamic_file_watchers(cmp_nvim_lsp.default_capabilities())
	end

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}

	return disable_dynamic_file_watchers(capabilities)
end

function M.config()
	local icons = require("user.icons")

	local servers = require("user.plugins.mason").servers

	local S = vim.diagnostic.severity
	local default_diagnostic_config = {
		signs = {
			text = {
				[S.ERROR] = icons.diagnostics.Error,
				[S.WARN] = icons.diagnostics.Warning,
				[S.HINT] = icons.diagnostics.Hint,
				[S.INFO] = icons.diagnostics.Information,
			},
			numhl = {
				[S.ERROR] = "DiagnosticSignError",
				[S.WARN] = "DiagnosticSignWarn",
				[S.HINT] = "DiagnosticSignHint",
				[S.INFO] = "DiagnosticSignInfo",
			},
		},
		-- built-in [d ]d [D ]D open the float after jumping
		jump = {
			on_jump = function(_, bufnr)
				vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
			end,
		},
		virtual_text = false,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			source = true,
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(default_diagnostic_config)

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			M.on_attach(client, ev.buf)
		end,
	})
	vim.lsp.config("*", {
		capabilities = M.common_capabilities(),
	})

	-- Per-server settings live in after/lsp/<server>.lua (merged automatically).
	-- rust_analyzer is installed by mason but started by rustaceanvim.
	vim.lsp.enable(vim.tbl_filter(function(s)
		return s ~= "rust_analyzer"
	end, servers))
end

return M
