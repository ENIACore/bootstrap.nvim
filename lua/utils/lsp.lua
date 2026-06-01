local M = {}

M.on_attach_remap = function(_, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "<leader>cl", function()
		local is_enabled = vim.lsp.codelens.is_enabled(opts)
		vim.lsp.codelens.enable(not is_enabled, opts)
	end, opts)

	-- Jump to definition
	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition({ border = "rounded" })
	end, opts)
	-- Display information
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover({ border = "rounded" })
	end, opts)
	-- grr shows all references
	-- gri shows implementation
	-- grt shows type definition
	-- grn renames the symbol under the cursor
	-- gra opens code actions
	-- grx run code lense action under cursor
	-- Search symbols across project
	vim.keymap.set("n", "<leader>gws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)

	--???
	vim.keymap.set("n", "<C-h>", function()
		vim.lsp.buf.signature_help({ border = "rounded" })
	end, opts)
end

return M
