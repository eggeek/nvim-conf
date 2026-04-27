local M = {
	"stevearc/conform.nvim",
	dependencies = {
		"williamboman/mason.nvim",
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua", lsp_format = "fallback" },
			python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
			tex = { "latexindent", "tex-fmt" , lsp_format = "fallback" },
			typst = { "typstyle", lsp_format = "fallback" },
			markdown = { "deno_fmt", "injected", lsp_format = "fallback" },
			json = { "deno_fmt", lsp_format = "fallback" },
			javascript = { "dprint", lsp_format = "fallback" },
			typescript = { "dprint", lsp_format = "fallback" },
			javascriptreact = { "dprint", lsp_format = "fallback" },
			typescriptreact = { "dprint", lsp_format = "fallback" },
			["*"] = { "trim_whitespace", "trim_newlines", "typos" },
		},
	},
	config = function(_, opts)
		-- 初始化 mason.nvim 和 conform.nvim
		require("conform").setup(opts)

		-- 辅助函数：从指定文件类型的配置中提取所有工具名称（去重）
		local function get_ensure_installed_for_ft(ft, ft_table)
			local tools = {}
			-- Filetype-specific tools
			local cfg = ft_table[ft]
			if type(cfg) == "table" then
				for _, item in ipairs(cfg) do
					if type(item) == "string" then
						tools[item] = true
					end
				end
			elseif type(cfg) == "string" then
				tools[cfg] = true
			end
			-- Global tools from ["*"]
			local global_cfg = ft_table["*"]
			if type(global_cfg) == "table" then
				for _, item in ipairs(global_cfg) do
					if type(item) == "string" then
						tools[item] = true
					end
				end
			end
			local list = {}
			for tool, _ in pairs(tools) do
				table.insert(list, tool)
			end
			return list
		end

		-- Map conform formatter names to Mason package names when they differ
		local conform_to_mason = {
			deno_fmt = "deno",
			ruff_format = "ruff",
			ruff_organize_imports = "ruff",
			ruff_fix = "ruff",
		}

		-- 设置 <leader>f 键映射，在按下时自动检测并安装缺失的工具后格式化代码
		vim.keymap.set({ "n", "v" }, "<leader>lf", function()
			local ft = vim.bo.filetype
			local tools = get_ensure_installed_for_ft(ft, opts.formatters_by_ft)
			local registry = require("mason-registry")
			for _, tool in ipairs(tools) do
				local pkg_name = conform_to_mason[tool] or tool
				local ok, pkg = pcall(registry.get_package, pkg_name)
				if ok and not pkg:is_installed() then
					vim.notify("Installing formatter: " .. pkg_name, vim.log.levels.INFO)
					pkg:install()
				end
			end
			require("conform").format({ async = true, lsp_fallback = true })
		end, { desc = "Code formatter (detect missing deps)" })
	end,
}
return M
