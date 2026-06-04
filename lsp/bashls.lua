local on_attach_remap = require("utils.lsp").on_attach_remap

return {
	cmd = { "bash-language-server", "start" },
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	on_attach = on_attach_remap,
	filetypes = { "sh", "bash" },
	root_markers = { ".git" },
	--[[
	root_dir = function(bufnr)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		print("fname is: " .. fname)
		local root = vim.fs.root(fname, { ".git" }) or vim.fs.dirname(fname)
		print("root is: " .. root)
		return root
	end,
    --]]
	settings = {
		bashIde = {
			globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
		},
	},
}
