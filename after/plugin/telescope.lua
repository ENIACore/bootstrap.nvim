--[[
-- Configures telescope (i.e fuzzy finder, previewer etc)
--]]
require("telescope").setup({
	defaults = {
		preview = {
			treesitter = false,
		},
		path_display = { "filename_first" },
	},
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
	builtin.live_grep()
end, {})
vim.keymap.set("n", "<leader>pS", function()
	local name = vim.fn.input("Ignore file-name text (case-insensitive): ")
	local additional_args = {}
	if name ~= "" then
		additional_args = { "--iglob", "!**/*" .. name .. "*" }
	end

	builtin.live_grep({
		additional_args = function()
			return additional_args
		end,
	})
end, { desc = "Telescope: live grep ignoring file-name text" })
