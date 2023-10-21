require 'user.dap-core'.common_dap_keymap()
require 'user.dap-core'.common_dap_conf()

require 'dap'.adapters.python = {
	type = 'executable',
	command = vim.fn.exepath('debugpy-adapter'),
}

