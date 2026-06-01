local on_attach_remap = require("utils.lsp").on_attach_remap

return {
	cmd = { "bash-language-server", "start" },
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	on_attach = on_attach_remap,
	filetypes = { "bash", "sh" },
	root_markers = { ".git" },
	settings = {
		bashIde = {
			globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
		},
	},
}
