return {
	"tpope/vim-fugitive",
	config = function()
		vim.api.nvim_create_autocmd("BufWinEnter", {
			pattern = "*",
			callback = function()
				if vim.wo.diff then
					vim.keymap.set("n", "<leader>go", ":diffget //2<CR>", { buffer = true, silent = true })
					vim.keymap.set("n", "<leader>gt", ":diffget //3<CR>", { buffer = true, silent = true })
				end
			end,
		})
	end,
}
