local on_attach_remap = require("utils.lsp").on_attach_remap

return {
	cmd = { "lemminx" },
	filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
	root_markers = { ".git" },
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	on_attach = on_attach_remap,
}
