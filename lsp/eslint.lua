local lsp = vim.lsp

local eslint_config_files = {
	".eslintrc",
	".eslintrc.js",
	".eslintrc.cjs",
	".eslintrc.yaml",
	".eslintrc.yml",
	".eslintrc.json",
	"eslint.config.js",
	"eslint.config.mjs",
	"eslint.config.cjs",
	"eslint.config.ts",
	"eslint.config.mts",
	"eslint.config.cts",
}

---@type vim.lsp.Config
return {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"astro",
		"htmlangular",
	},
	workspace_required = true,
	on_attach = function(client, bufnr)
		-- Define the LspEslintFixAll command
		vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
			client:request_sync("workspace/executeCommand", {
				command = "eslint.applyAllFixes",
				arguments = {
					{
						uri = vim.uri_from_bufnr(bufnr),
						version = lsp.util.buf_versions[bufnr],
					},
				},
			}, nil, bufnr)
		end, {})

		-- Custom keybindings
		require("utils.lsp").on_attach_remap(client, bufnr)

		-- Auto-fix on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "LspEslintFixAll",
		})
	end,
	root_dir = function(bufnr, on_dir)
		local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
		root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
			or vim.list_extend(root_markers, { ".git" })

		if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
			return
		end

		local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

		local filename = vim.api.nvim_buf_get_name(bufnr)
		local is_buffer_using_eslint = vim.fs.find(eslint_config_files, {
			path = filename,
			type = "file",
			limit = 1,
			upward = true,
			stop = vim.fs.dirname(project_root),
		})[1]
		if not is_buffer_using_eslint then
			return
		end

		on_dir(project_root)
	end,
	settings = {
		validate = "on",
		packageManager = nil,
		useESLintClass = false,
		experimental = {},
		codeActionOnSave = {
			enable = false,
			mode = "all",
		},
		format = true,
		quiet = false,
		onIgnoredFiles = "off",
		rulesCustomizations = {},
		run = "onType",
		problems = {
			shortenToSingleLine = false,
		},
		nodePath = "",
		workingDirectory = { mode = "auto" },
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
	},
	before_init = function(_, config)
		local root_dir = config.root_dir

		if root_dir then
			config.settings = config.settings or {}
			config.settings.workspaceFolder = {
				uri = root_dir,
				name = vim.fn.fnamemodify(root_dir, ":t"),
			}

			local pnp_cjs = root_dir .. "/.pnp.cjs"
			local pnp_js = root_dir .. "/.pnp.js"
			if type(config.cmd) == "table" and (vim.uv.fs_stat(pnp_cjs) or vim.uv.fs_stat(pnp_js)) then
				config.cmd = vim.list_extend({ "yarn", "exec" }, config.cmd --[[@as table]])
			end
		end
	end,
	handlers = {
		["eslint/openDoc"] = function(_, result)
			if result then
				vim.ui.open(result.url)
			end
			return {}
		end,
		["eslint/confirmESLintExecution"] = function(_, result)
			if not result then
				return
			end
			return 4 -- approved
		end,
		["eslint/probeFailed"] = function()
			vim.notify("ESLint probe failed.", vim.log.levels.WARN)
			return {}
		end,
		["eslint/noLibrary"] = function()
			vim.notify("Unable to find ESLint library.", vim.log.levels.WARN)
			return {}
		end,
	},
}
