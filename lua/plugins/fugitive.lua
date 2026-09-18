return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>go", function()
			pcall(vim.cmd, "diffget //2")
		end, { silent = true, desc = "Diffget ours (stage 2)" })
		vim.keymap.set("n", "<leader>gt", function()
			pcall(vim.cmd, "diffget //3")
		end, { silent = true, desc = "Diffget theirs (stage 3)" })
	end,
}
