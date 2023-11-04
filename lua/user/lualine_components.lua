local window_width_limit = 100

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  hide_in_width = function()
    return vim.o.columns > window_width_limit
  end,
  -- check_git_workspace = function()
  --   local filepath = vim.fn.expand "%:p:h"
  --   local gitdir = vim.fn.finddir(".git", filepath .. ";")
  --   return gitdir and #gitdir > 0 and #gitdir < #filepath
  -- end,
}

local colors = {
  bg = "#202328",
  fg = "#bbc2cf",
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  purple = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}

local icons = require 'user.icons'
local icons_kind = icons.kind

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local function env_cleanup(venv)
  if string.find(venv, "/") then
    local final_venv = venv
    for w in venv:gmatch "([^/]+)" do
      final_venv = w
    end
    venv = final_venv
  end
  return venv
end

-- local branch = icons.git.Branch
local branch = "%#SLGitIcon#" .. icons.git.Branch .. "%*" .. "%#SLBranchName#"

return {
  mode = {
    function()
      return " " .. icons.ui.Target .. " "
    end,
    padding = { left = 0, right = 0 },
    color = {},
    cond = nil,
  },
  branch = {
    "b:gitsigns_head",
    icon = branch,
    color = { gui = "bold" },
  },
  filename = {
    "filename",
    color = {},
    cond = nil,
  },
  diff = {
    "diff",
    source = diff_source,
    symbols = {
      added = icons.git.LineAdded .. " ",
      modified = icons.git.LineModified .. " ",
      removed = icons.git.LineRemoved .. " ",
    },
    padding = { left = 1, right = 1 },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed = { fg = colors.red },
    },
    cond = nil,
  },
  python_env = {
    function()
      if vim.bo.filetype == "python" then
        local venv = os.getenv "CONDA_DEFAULT_ENV" or os.getenv "VIRTUAL_ENV"
        if venv then
          local py_icon, _ = require "nvim-web-devicons".get_icon ".py"
          return string.format(" " .. py_icon .. " (%s)", env_cleanup(venv))
        end
      end
      return ""
    end,
    color = { fg = colors.green },
    cond = conditions.hide_in_width,
  },
  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
      error = icons.diagnostics.BoldError .. " ",
      warn = icons.diagnostics.BoldWarning .. " ",
      info = icons.diagnostics.BoldInformation .. " ",
      hint = icons.diagnostics.BoldHint .. " ",
    },
    cond = conditions.hide_in_width,
  },
  treesitter = {
    function()
      return icons.ui.Tree
    end,
    color = function()
      local buf = vim.api.nvim_get_current_buf()
      local ts = vim.treesitter.highlighter.active[buf]
      return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red }
    end,
    cond = conditions.hide_in_width,
  },
  lsp = {
    function()
      local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
      if #buf_clients == 0 then
        return "LSP Inactive"
      end

      local buf_ft = vim.bo.filetype
      local buf_client_names = {}
      local copilot_active = false

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" and client.name ~= "copilot" then
          table.insert(buf_client_names, client.name)
        end

        if client.name == "copilot" then
          copilot_active = true
        end
      end

      local unique_client_names = vim.fn.uniq(buf_client_names)

      local language_servers = "[" .. table.concat(unique_client_names, ", ") .. "]"

      if copilot_active then
        language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
      end

      return language_servers
    end,
    color = { gui = "bold" },
    cond = conditions.hide_in_width,
  },
  location = { "location" },
  progress = {
    "progress",
    fmt = function()
      return "%P/%L"
    end,
    color = {},
  },

  spaces = {
    function()
      local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
      return icons.ui.Tab .. " " .. shiftwidth
    end,
    padding = 1,
  },
  encoding = {
    "o:encoding",
    fmt = string.upper,
    color = {},
    cond = conditions.hide_in_width,
  },
  filetype = { "filetype", cond = nil, padding = { left = 1, right = 1 } },
  scrollbar = {
    function()
      local current_line = vim.fn.line "."
      local total_lines = vim.fn.line "$"
      local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
      local line_ratio = current_line / total_lines
      local index = math.ceil(line_ratio * #chars)
      return chars[index]
    end,
    padding = { left = 0, right = 0 },
    color = "SLProgress",
    cond = nil,
  },
  navic_opts = {
    icons = {
      Array = icons_kind.Array .. " ",
      Boolean = icons_kind.Boolean .. " ",
      Class = icons_kind.Class .. " ",
      Color = icons_kind.Color .. " ",
      Constant = icons_kind.Constant .. " ",
      Constructor = icons_kind.Constructor .. " ",
      Enum = icons_kind.Enum .. " ",
      EnumMember = icons_kind.EnumMember .. " ",
      Event = icons_kind.Event .. " ",
      Field = icons_kind.Field .. " ",
      File = icons_kind.File .. " ",
      Folder = icons_kind.Folder .. " ",
      Function = icons_kind.Function .. " ",
      Interface = icons_kind.Interface .. " ",
      Key = icons_kind.Key .. " ",
      Keyword = icons_kind.Keyword .. " ",
      Method = icons_kind.Method .. " ",
      Module = icons_kind.Module .. " ",
      Namespace = icons_kind.Namespace .. " ",
      Null = icons_kind.Null .. " ",
      Number = icons_kind.Number .. " ",
      Object = icons_kind.Object .. " ",
      Operator = icons_kind.Operator .. " ",
      Package = icons_kind.Package .. " ",
      Property = icons_kind.Property .. " ",
      Reference = icons_kind.Reference .. " ",
      Snippet = icons_kind.Snippet .. " ",
      String = icons_kind.String .. " ",
      Struct = icons_kind.Struct .. " ",
      Text = icons_kind.Text .. " ",
      TypeParameter = icons_kind.TypeParameter .. " ",
      Unit = icons_kind.Unit .. " ",
      Value = icons_kind.Value .. " ",
      Variable = icons_kind.Variable .. " ",
    },
    click = true,
    separator = '  ',
    depth_limit = 6,
    highlight = true,
    depth_limit_indicator = "..",
  },
  winbar_fname = function()
    local bufs = vim.fn.tabpagebuflist()
    local tabcnt = #vim.api.nvim_list_tabpages()
    local rec = {}
    local cnt = 0
    for _, bid in ipairs(bufs) do
      local bufname = vim.api.nvim_buf_get_name(bid)
      -- bufname must not empty and not a terminal buffer
      if bufname:len() > 0 and bufname:sub(1, #"term://") ~= "term://" and rec[bid] ~= true then
        rec[bid] = true
        cnt = cnt + 1
      end
    end

    if cnt > 1 or tabcnt == 1 then
        local fpath = vim.api.nvim_eval_statusline("%f", {}).str
        if fpath:sub(1, #"term://") == "term://" then
          return ""
        end
        fpath = fpath:gsub('/', '  ')
        local mod = vim.api.nvim_eval_statusline("%m", {}).str
        return '%=' .. fpath .. mod .. '%='
    else
      return ""
    end

  end,

}
