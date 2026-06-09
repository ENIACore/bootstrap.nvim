--[[
-- Automatically ensures linters are installed and enabled
--]]
local registry = require("utils.registry")
local linters = {
	"checkstyle",
	"ruff",
}
registry:install_pkg_list(linters)

local lint = require("lint")
lint.linters_by_ft = {
	java = { "checkstyle" },
	-- javascript = { "jshint" }, -- jshint installed manually via `npm install -g jshint`
	-- python = { "ruff" }, -- Disable due to identical errors with lsp
}

require("lint.linters.checkstyle").config_file = vim.fn.expand("~/.config/nvim/lint/java-checkstyle.xml")

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})
vim.keymap.set("n", "<leader>l", function()
	lint.try_lint()
end, { desc = "Trigger linting for current file" })
