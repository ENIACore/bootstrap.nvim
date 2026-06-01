--[[
-- Automatically ensures linters are installed and enabled
--]]
local registry = require("utils.registry")
local linters = {
	"checkstyle",
}
registry:install_pkg_list(linters)

local lint = require("lint")
lint.linters_by_ft = {
	java = { "checkstyle" },
}

require("lint.linters.checkstyle").config_file = vim.fn.expand("~/.config/nvim/lint/java_checkstyle.xml")

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
