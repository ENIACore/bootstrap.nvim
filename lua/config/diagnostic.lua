vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end)

-- Remove 'H', 'W', and 'E' warnings on left side of window, and display as virtual text
vim.diagnostic.config({
	signs = false,
	virtual_text = true,
})
