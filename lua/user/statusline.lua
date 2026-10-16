local M = {}
local mini = require("mini.statusline")
local icons = require("user.icons")
local last_window
local pending = false
local bg, fg = "#222831", "#abb2bf"
local navic_opts = { icons = {}, click = true, separator = "  ", depth_limit = 6,
  highlight = true, depth_limit_indicator = "..", safe_output = true }
for kind, icon in pairs(icons.kind) do navic_opts.icons[kind] = icon .. " " end

local function escape(text)
  return (text:gsub("%%", "%%%%"):gsub("[\r\n]", " "))
end

local function highlights()
  local set = vim.api.nvim_set_hl
  for mode, color in pairs({ Normal = "#98c379", Insert = "#61afef", Visual = "#c678dd",
    Replace = "#e06c75", Command = "#e5c07b", Other = "#56b6c2" }) do
    set(0, "MiniStatuslineMode" .. mode, { fg = bg, bg = color, bold = true })
  end
  -- Other statusline groups are drawn over StatusLine, so they inherit its background.
  set(0, "StatusLine", { fg = fg, bg = bg })
  set(0, "UserStatuslineBold", { bold = true })
  set(0, "UserStatuslinePython", { fg = "#98be65" })
  -- onedark.lua defines this; the fallback covers other colorschemes.
  set(0, "UserStatuslineSignature", { fg = "#e5c07b", default = true })
  -- Native current/other window bars, bold, keeping the colorscheme's background.
  for name, color in pairs({ WinBar = false, WinBarNC = "grey" }) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    hl.fg, hl.bold = color or hl.fg, true
    set(0, name, hl)
  end
end

local function context()
  local sig = package.loaded.lsp_signature
  if sig and vim.fn.mode():sub(1, 1) == "i" then
    local value = sig.status_line(math.floor(vim.o.columns / 2))
    if value.label ~= "" then
      return "%#UserStatuslineSignature#" .. escape(value.label
        .. (value.hint ~= "" and ("  [" .. value.hint .. "]") or ""))
    end
  end
  local navic = package.loaded["nvim-navic"]
  if navic and navic.is_available() then
    return navic.get_location(navic_opts)
  end
  return ""
end

local function diagnostics()
  local count, parts = vim.diagnostic.count(0), {}
  for index, level in ipairs({ "Error", "Warn", "Info", "Hint" }) do
    if (count[index] or 0) > 0 then
      local symbol = icons.diagnostics["Bold" .. ({ "Error", "Warning", "Information", "Hint" })[index]]
      parts[#parts + 1] = "%#Diagnostic" .. level .. "#" .. symbol .. " " .. count[index]
    end
  end
  return table.concat(parts, " ")
end

local function servers()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "LSP Inactive" end
  local names, seen, copilot = {}, {}, false
  for _, client in ipairs(clients) do
    if client.name == "copilot" then
      copilot = true
    elseif client.name ~= "null-ls" and not seen[client.name] then
      names[#names + 1], seen[client.name] = escape(client.name), true
    end
  end
  return "[" .. table.concat(names, ", ") .. "]"
    .. (copilot and ("%#SLCopilot# " .. icons.git.Octoface .. "%#UserStatuslineBold#") or "")
end

local function filetype()
  if vim.bo.filetype == "" then return "" end
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then return escape(vim.bo.filetype) end
  local icon, hl = devicons.get_icon(vim.fn.expand("%:t"))
  if not icon then icon, hl = devicons.get_icon_by_filetype(vim.bo.filetype) end
  return "%#" .. (hl or "DevIconDefault") .. "#" .. (icon or "")
    .. "%#StatusLine# " .. escape(vim.bo.filetype)
end

local function content()
  if vim.bo.filetype == "alpha" then return "" end
  local _, mode_hl = mini.section_mode({})
  local dap = package.loaded["user.dap.core"]
  local branch = vim.b.gitsigns_head
  local git = branch and branch ~= "" and ("%#SLGitIcon#" .. icons.git.Branch
    .. "%#SLBranchName# " .. escape(branch) .. "%#StatusLine#") or ""
  local wide = vim.o.columns > 100
  local env = wide and vim.bo.filetype == "python" and (vim.env.VIRTUAL_ENV_PROMPT or vim.env.CONDA_DEFAULT_ENV)
  local python = env and ("[" .. escape(env:match("([^/]+)/?$") or env) .. "]") or ""
  local line, total = vim.fn.line("."), vim.fn.line("$")
  local progress = line == 1 and "Top" or (line == total and "Bot" or string.format("%2d%%%%", math.floor(line / total * 100)))
  return mini.combine_groups({
    "%#" .. mode_hl .. "#^•⩊•^",
    { hl = mode_hl, strings = { dap and dap.active() and "DEBUG" or "" } },
    { hl = "UserStatuslineBold", strings = { git } },
    "%<",
    { hl = "StatusLine", strings = { context() } },
    "%=",
    { hl = "StatusLine", strings = { wide and diagnostics() or "" } },
    { hl = "UserStatuslineBold", strings = { wide and servers() or "" } },
    { hl = "StatusLine", strings = { icons.ui.Tab .. " " .. vim.bo.shiftwidth } },
    { hl = "UserStatuslinePython", strings = { python } },
    { hl = "StatusLine", strings = { filetype(), string.format("%3d:%-2d", line, vim.fn.charcol(".")) } },
    { hl = mode_hl, strings = { progress } },
  })
end

function M.active()
  if vim.bo.filetype == "NvimTree" and last_window and vim.api.nvim_win_is_valid(last_window)
      and vim.api.nvim_win_get_tabpage(last_window) == vim.api.nvim_get_current_tabpage() then
    return vim.api.nvim_win_call(last_window, content)
  end
  return content()
end

local function named_file(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  return name ~= "" and not vim.startswith(name, "term://")
    and not vim.endswith(name, "BqfPreviewFloatWin") and not vim.endswith(name, "BqfPreviewScrollBar")
end

function M.winbar()
  local name = vim.api.nvim_eval_statusline("%f", { winid = vim.api.nvim_get_current_win() }).str
  return "%=" .. escape(name):gsub("/", "  ") .. "%m%="
end

local function winbars()
  local seen, count = {}, 0
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_win_get_config(win).relative == "" and named_file(buf) and not seen[buf] then
      seen[buf], count = true, count + 1
    end
  end
  local show = count > 1 or #vim.api.nvim_list_tabpages() == 1
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local normal = vim.api.nvim_win_get_config(win).relative == ""
    local visible = show and normal and vim.bo[buf].buftype ~= "terminal" and vim.bo[buf].filetype ~= "alpha"
      and not vim.startswith(vim.api.nvim_buf_get_name(buf), "term://")
    vim.wo[win].winbar = visible and "%{%v:lua.require'user.statusline'.winbar()%}" or ""
  end
end

function M.refresh()
  -- Window-bar visibility follows layout changes; cursor and mode redraws are native.
  -- Coalesce event bursts; never queue more than one callback. No polling timer.
  if pending then return end
  pending = true
  vim.schedule(function()
    pending = false
    winbars()
    vim.cmd("redrawstatus!")
  end)
end

function M.attach_signature(buf)
  local signature = require("lsp_signature")
  -- Re-attaching a second server must not duplicate the buffer's handlers.
  for _, name in ipairs({ "lsp_signature", "Signature", "UserSignature" }) do
    local group = vim.api.nvim_create_augroup(name, { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, buffer = buf })
  end
  signature.on_attach({ floating_window = false, hint_enable = false, doc_lines = 0,
    toggle_key = "<M-x>", select_signature_key = "<M-n>" }, buf)
  -- The installed plugin's InsertEnter starts an unbounded schedule_wrap timer.
  -- Use its public request API on changes instead; keep its cleanup and keys.
  vim.api.nvim_clear_autocmds({ group = "lsp_signature", buffer = buf, event = "InsertEnter" })
  local scheduled = false
  vim.api.nvim_create_autocmd({ "InsertEnter", "TextChangedI", "TextChangedP" }, {
    group = "UserSignature", buffer = buf, callback = function(args)
      if scheduled then return end
      scheduled = true
      -- InsertEnter runs before mode() changes; query after the transition.
      vim.schedule(function()
        scheduled = false
        if vim.api.nvim_get_current_buf() == buf and vim.fn.mode():sub(1, 1) == "i" then
          signature.signature(args.event == "InsertEnter" and { trigger = "InsertEnter" } or nil)
        end
      end)
    end,
  })
end

function M.setup()
  mini.setup({ content = { active = M.active } })
  local group = vim.api.nvim_create_augroup("UserStatusline", { clear = true })
  local function remember_window()
    if vim.bo.filetype ~= "NvimTree" and vim.api.nvim_win_get_config(0).relative == "" then
      last_window = vim.api.nvim_get_current_win()
    end
    M.refresh()
  end
  vim.api.nvim_create_autocmd("WinLeave", { group = group, callback = remember_window })
  vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "BufAdd", "BufDelete", "BufHidden", "BufFilePost", "BufModifiedSet",
    "BufWritePost", "WinClosed", "TabEnter", "TabClosed", "FileType" },
    { group = group, callback = M.refresh })
  vim.api.nvim_create_autocmd("OptionSet", { group = group, pattern = "shiftwidth", callback = M.refresh })
  vim.api.nvim_create_autocmd("User", { group = group, pattern = "GitSignsUpdate", callback = M.refresh })
  vim.api.nvim_create_autocmd("LspRequest", { group = group, callback = function(args)
    local request = args.data.request
    if request.type ~= "complete" then return end
    if request.method == "textDocument/documentSymbol" and args.buf == vim.api.nvim_get_current_buf() then
      -- navic stores new symbols but only recomputes the cursor's scope on cursor movement.
      -- The reply handler runs after this autocmd, so update after it.
      vim.schedule(function()
        if vim.api.nvim_get_current_buf() == args.buf then require("nvim-navic.lib").update_context(args.buf) end
      end)
    end
    if request.method == "textDocument/signatureHelp" or request.method == "textDocument/documentSymbol" then
      M.refresh()
    end
  end })
  vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = function()
    highlights()
    M.refresh()
  end })
  highlights()
  remember_window()
end

return M
