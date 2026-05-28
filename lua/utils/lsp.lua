local M = {}

M.on_attach_remap = function(_, bufnr)
	local opts = {buffer = bufnr, remap = false}
	-- Jump to definition
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition({border = 'rounded'}) end, opts)
	-- Display information
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover({border = 'rounded'}) end, opts)
	-- Search symbols across project
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	-- Get code actions
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action({border = 'rounded'}) end, opts)
	-- Get references
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	-- Rename symbol everywhere in the project
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	-- Show signature of function (same as hover?)
	vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help({border = 'rounded'}) end, opts)

end

return M
