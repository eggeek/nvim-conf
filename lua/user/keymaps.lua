local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
  insert_mode = generic_opts_any,
  normal_mode = generic_opts_any,
  visual_mode = generic_opts_any,
  visual_block_mode = generic_opts_any,
  command_mode = generic_opts_any,
  operator_pending_mode = generic_opts_any,
  term_mode = { silent = true },
}

local mode_adapters = {
  insert_mode = "i",
  normal_mode = "n",
  term_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
  operator_pending_mode = "o",
}

local mode_adapters_rev = {
  n = "normal_mode",
  x = "visual_block_mode",
}

---@class Keys
---@field insert_mode table
---@field normal_mode table
---@field terminal_mode table
---@field visual_mode table
---@field visual_block_mode table
---@field command_mode table
---@field operator_pending_mode table

local defaults = {
  insert_mode = {
    ["<C-s>"] = "<cmd>w<cr><esc>",
    -- emacs style
    ["<C-p>"] = "<Up>",
    ["<C-n>"] = "<Down>",
    ["<C-f>"] = "<Right>",
    ["<C-b>"] = "<Left>",
    -- use normal! rather than <C-O> to avoid trigger events
    ["<C-k>"] = "<cmd>normal!d$<cr><END>",
    ["<C-a>"] = "<cmd>normal!^<cr>",
    ["<C-e>"] = "<END>",
  },

  normal_mode = {

    -- Fzf
    ["z="]         = "<cmd>call FzfSpell()<cr>",

    -- Resize with arrows
    ["<C-Up>"]     = ":resize -2<CR>",
    ["<C-Down>"]   = ":resize +2<CR>",
    ["<C-Left>"]   = ":vertical resize -2<CR>",
    ["<C-Right>"]  = ":vertical resize +2<CR>",

    -- QuickFix
    ["]q"]         = ":cnext<CR>",
    ["[q"]         = ":cprev<CR>",

    -- Diagnostic
    ["[d"]         = "<cmd>lua vim.diagnostic.goto_prev()<cr>",
    ["]d"]         = "<cmd>lua vim.diagnostic.goto_next()<cr>",
    ["<leader>q"]  = "<cmd>lua vim.diagnostic.setloclist()<cr>",
    ["<leader>df"] = "<cmd>lua vim.diagnostic.open_float()<cr>",
    ["<leader>dl"] = function()
      local current_value = vim.diagnostic.config().virtual_text
      if current_value then
        vim.diagnostic.config({ virtual_text = false })
      else
        vim.diagnostic.config({ virtual_text = true })
      end
    end,

    -- nohl
    ["<M-l>"]      = "<cmd>nohlsearch<Bar>diffupdate<Bar>echo <CR>",

    -- Horizontal scroll
    ["<M-e>"]      = "zh",
    ["<M-y>"]      = "zl",

    -- Keey centered
    ["n"]          = "nzzzv",
    ["N"]          = "Nzzzv",
    ["J"]          = "mzJ`z",

    -- Telescope
    ["<C-p>"]      = "<cmd>Telescope find_files previewer=false<cr>",
    ["<leader>/"]  = "<cmd>Telescope grep_string<cr>",
    ["<leader>;"]  = "<cmd>Telescope live_grep<cr>",
    ["<leader>sd"] = "<cmd>Telescope diagnostics<cr>",
    ["<leader>sr"] = "<cmd>Telescope resume<cr>",
    ["<leader>mp"] = "<cmd>Telescope keymaps<cr>",
    ["<M-x>"]      = "<cmd>Telescope commands<cr>",
    ["<M-o>"]      = "<cmd>Telescope lsp_document_symbols symbols=module,function,method,class<cr>",

    ["<C-s>"]      = "<cmd>w<cr>",
    ["<leader>1"]  = "1gt",
    ["<leader>2"]  = "2gt",
    ["<leader>3"]  = "3gt",
    ["<leader>4"]  = "4gt",
    ["<leader>5"]  = "5gt",
    ["<leader>6"]  = "6gt",
    ["<leader>7"]  = "7gt",
    ["<leader>tc"] = "<cmd>tabnew<cr>",
    ["<leader>tp"] = "<cmd>tabprev<cr>",
    ["<leader>tn"] = "<cmd>tabnext<cr>",
    ["<leader>z"]  = "<cmd>ColorizerToggle<cr>",

    -- Lsp
    ["<leader>lf"] = "<cmd>lua vim.lsp.buf.format({timeout_ms = 1000000})<cr>",
    ["<leader>ca"] = "<cmd>lua vim.lsp.buf.code_action()<cr>",
  },

  term_mode = {
    -- Terminal window navigation
    ["<C-h>"] = "<C-\\><C-N><C-w>h",
    ["<C-j>"] = "<C-\\><C-N><C-w>j",
    ["<C-k>"] = "<C-\\><C-N><C-w>k",
    ["<C-l>"] = "<C-\\><C-N><C-w>l",
  },

  visual_mode = {
    -- Better indenting
    ["<"] = "<gv",
    [">"] = ">gv",

    -- Move current line / block with Alt-j/k ala vscode.
    ["J"] = ":m '>+1<cr>gv=gv",
    ["K"] = ":m '<-2<cr>gv=gv",

  },

  visual_block_mode = {
    -- Move current line / block with Alt-j/k ala vscode.
    ["J"] = ":m '>+1<CR>gv-gv",
    ["K"] = ":m '<-2<CR>gv-gv",
  },

  command_mode = {
    -- navigate tab completion with <c-j> and <c-k>
    -- runs conditionally
    ["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
    ["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },

    -- emacs style
    -- ["<C-f>"] = "<Right>",
    -- ["<C-b>"] = "<Left>",
    -- ["<C-a>"] = "<Home>",
    -- ["<C-e>"] = "<End>",
  },
}


-- Unsets all keybindings defined in keymaps
-- @param keymaps The table of key mappings containing a list per mode (normal_mode, insert_mode, ..)
function M.clear(keymaps)
  local default = M.get_defaults()
  for mode, mappings in pairs(keymaps) do
    local translated_mode = mode_adapters[mode] and mode_adapters[mode] or mode
    for key, _ in pairs(mappings) do
      -- some plugins may override default bindings that the user hasn't manually overriden
      if default[mode][key] ~= nil or (default[translated_mode] ~= nil and default[translated_mode][key] ~= nil) then
        pcall(vim.api.nvim_del_keymap, translated_mode, key)
      end
    end
  end
end

-- Set key mappings individually
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param key The key of keymap
-- @param val Can be form as a mapping or tuple of mapping and user defined opt
function M.set_keymaps(mode, key, val)
  local opt = generic_opts[mode] or generic_opts_any
  if type(val) == "table" then
    opt = val[2]
    val = val[1]
  end
  if val then
    vim.keymap.set(mode, key, val, opt)
  else
    pcall(vim.api.nvim_del_keymap, mode, key)
  end
end

-- Load key mappings for a given mode
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param keymaps The list of key mappings
function M.load_mode(mode, keymaps)
  mode = mode_adapters[mode] or mode
  for k, v in pairs(keymaps) do
    M.set_keymaps(mode, k, v)
  end
end

-- Load key mappings for all provided modes
-- @param keymaps A list of key mappings for each mode
function M.load(keymaps)
  keymaps = keymaps or {}
  for mode, mapping in pairs(keymaps) do
    M.load_mode(mode, mapping)
  end
end

-- Load the default keymappings
function M.load_defaults()
  M.load(M.get_defaults())
end

-- Get the default keymappings
function M.get_defaults()
  return defaults
end

function M.get_defaults_mode(mode)
  if defaults[mode] ~= nil then
    return defaults[mode]
  else
    return defaults[mode_adapters_rev[mode]]
  end
end

return M
