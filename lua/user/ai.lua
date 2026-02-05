local M = {
	"zbirenbaum/copilot.lua",
	requires = {
		"copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
	},
	cmd = "Copilot",
	event = "InsertEnter",
}

M.config = function()
	require("copilot").setup({
		suggestion = {
			enabled = true,
			auto_trigger = true,
			accept = false,
		},
		panel = {
			enabled = false
		},
		filetypes = {
			python = true,
			lua = true,
			typst = true,
			tex = true,
			["*"] = false
		}
	})
end

return M
