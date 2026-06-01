--[[
-- Defines path to debug and test jars used by nvim dap
--]]
local mason_registry = require("mason-registry")
local bundles = {}
-- java-debug-adapter
local java_debug = mason_registry.get_package("java-debug-adapter")
local debug_path = java_debug:get_install_path()
vim.list_extend(
	bundles,
	vim.fn.glob(debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
)
-- java-test (vscode-java-test)
local java_test = mason_registry.get_package("java-test")
local test_path = java_test:get_install_path()
vim.list_extend(bundles, vim.fn.glob(test_path .. "/extension/server/*.jar", true, true))

local on_attach_remap = require("utils.lsp").on_attach_remap

-- Create cache and worskpace directory
-- Stores data (indexes etc) related to project in .../workspaces/<project base dir name>
vim.fn.mkdir(vim.fn.expand("~/.cache/nvim/jdtls/workspaces"), "p")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.expand("~/.cache/nvim/jdtls/workspaces/") .. project_name

local config = {
	name = "jdtls",

	-- Command invoked by mason, use --jvm-arg to pass additional args to java (21) jdtls program
	cmd = {
		"jdtls",
		"-data",
		workspace_dir,
		"--jvm-arg=-Xmx8G", -- RAM allocated to jdtls
	},

	-- Markers to determine root of project
	root_dir = vim.fs.root(0, { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }),

	-- Adds auto completion
	capabilities = require("cmp_nvim_lsp").default_capabilities(),

	on_attach = function(client, bufnr)
		on_attach_remap(client, bufnr)

		local opts = { buffer = true, silent = true }

		vim.keymap.set("n", "<C-o>", require("jdtls").organize_imports, opts) -- TODO add to: gopls, tsserver, pylsp
		vim.keymap.set("n", "crv", require("jdtls").extract_variable, opts) -- TODO: add to rust-analyzer, clangd, pylsp
		vim.keymap.set("v", "crv", function()
			require("jdtls").extract_variable({ visual = true })
		end, opts) -- TODO: add to rust-analyzer, clangd, pylsp
		vim.keymap.set("n", "crc", require("jdtls").extract_constant, opts) -- TODO: add to rust-analyzer, clangd
		vim.keymap.set("v", "crc", function()
			require("jdtls").extract_constant({ visual = true })
		end, opts) -- TODO: add to rust-analyzer, clangd
		vim.keymap.set("v", "crm", function()
			require("jdtls").extract_method({ visual = true })
		end, opts) -- TODO: add to rust-analyzer, clangd, pylsp

		-- nvim-dap (if using)
		vim.keymap.set("n", "<leader>df", require("jdtls").test_class, opts)
		vim.keymap.set("n", "<leader>dn", require("jdtls").test_nearest_method, opts)
	end,

	-- Here you can configure eclipse.jdt.ls specific settings, see https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request for a list of options
	settings = {
		format = { enabled = true, tabSize = 4 },
		imports = { gradle = { enabled = true } },
		java = {
			configuration = {
				-- Java runtime versions available - correct version used by debugger when running project and showing errors
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = "/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home",
					},
					{
						name = "JavaSE-11",
						path = "/opt/homebrew/Cellar/openjdk@11/11.0.31/libexec/openjdk.jdk/Contents/Home",
					},
					{
						name = "JavaSE-17",
						path = "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home",
					},
					{
						name = "JavaSE-26",
						path = "/opt/homebrew/Cellar/openjdk/26.0.1/libexec/openjdk.jdk/Contents/Home",
						default = true, -- used when no project-level version is detected
					},
				},
			},
		},
	},

	init_options = {
		-- Used to list jars (java-debug and vscode-java-test) that work with nvim plugins to communicate with jdtls
		bundles = bundles,
		jvm_args = {
			"-Djava.import.generatesMetadataFilesAtProjectRoot=false", -- Prevents .classpath and .project files in project root directory
		},
		codelens = {
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
		},
	},
}
require("jdtls").start_or_attach(config)
