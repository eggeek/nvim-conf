require 'user.dap-core'.common_dap_keymap()
require 'user.dap-core'.common_dap_conf()

require 'dap'.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = vim.fn.exepath('OpenDebugAD7'),
}
