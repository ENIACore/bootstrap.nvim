local capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach_remap = require("utils.lsp").on_attach_remap

return {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "markdown.mdx" },
	root_markers = { ".marksman.toml", ".git" },
	capabilities = capabilities,
	on_attach = on_attach_remap,
}
