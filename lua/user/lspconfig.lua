local M = {
	"neovim/nvim-lspconfig",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"folke/neodev.nvim",
			"mason-lspconfig.nvim",
			"ray-x/lsp_signature.nvim",
		},
	},
}

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr}
	local keymap = vim.keymap.set
	keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	-- keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	keymap('n', 'K', function()
		vim.lsp.buf.hover({ border = "rounded" })
	end, opts)
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
	require "lsp_signature".on_attach({
		floating_window = false,
		hint_enable = false,          -- virtual hint enable
		doc_line = 0,
		toggle_key = '<M-x>',         -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
		select_signature_key = '<M-n>', -- cycle to next signature, e.g. '<M-n>' function overloading
	}, bufnr)                       -- Note: add in lsp client on-attach
	if client.server_capabilities.documentSymbolProvider then
		require 'nvim-navic'.attach(client, bufnr)
	end
end

function M.common_capabilities()
	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_ok then
		return cmp_nvim_lsp.default_capabilities()
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

	return capabilities
end

function M.config()
	local icons = require "user.icons"

	local servers = require "user.mason".servers

	local default_diagnostic_config = {
		signs = {
			active = true,
			values = {
				{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
				{ name = "DiagnosticSignWarn",  text = icons.diagnostics.Warning },
				{ name = "DiagnosticSignHint",  text = icons.diagnostics.Hint },
				{ name = "DiagnosticSignInfo",  text = icons.diagnostics.Information },
			},
		},
		virtual_text = false,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(default_diagnostic_config)

	for _, sign in ipairs(vim.tbl_get(default_diagnostic_config, "signs", "values") or {}) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
	end

	-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	-- require("lspconfig.ui.windows").default_options.border = "rounded"

	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('UserLspConfig', {}),
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			M.on_attach(client, ev.buf)
		end
	})
	vim.lsp.config('*', {
		capabilities = M.common_capabilities()
	})

	-- not to config the following servers in lspconfig
	local skip_servers = {
		"rust_analyzer"
	}
	for _, server in pairs(servers) do
		if require "user/utils".table_contains(skip_servers, server) then
			goto continue
		end
		local opts = { }
		local require_ok, settings = pcall(require, "user.lspsettings." .. server)
		if require_ok then
			opts = vim.tbl_deep_extend("force", settings, opts)
		end

		if server == "lua_ls" then
			require("neodev").setup {
				library = { plugins = { "nvim-dap-ui" }, types = true },
			}
		end
		vim.lsp.config(server, {
			settings = { [server] = opts }
		})
		vim.lsp.enable(server, true)
		::continue::
	end
end

return M
