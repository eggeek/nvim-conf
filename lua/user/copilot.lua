return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			accept = false,
		},
		panel = {
			enabled = false,
		},
		filetypes = {
			python = true,
			lua = true,
			typst = true,
			tex = true,
			rust = true,
			cpp = true,
			["*"] = false,
		},
	},
}
