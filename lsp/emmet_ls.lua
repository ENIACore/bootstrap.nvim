local on_attach_remap = require("utils.lsp").on_attach_remap

return {
	cmd = { "emmet-ls", "--stdio" },
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	on_attach = on_attach_remap,
	filetypes = {
		"astro",
		"css",
		"eruby",
		"html",
		"htmlangular",
		"htmldjango",
		"javascriptreact",
		"less",
		"pug",
		"sass",
		"scss",
		"svelte",
		"templ",
		"typescriptreact",
		"vue",
	},
	root_markers = { ".git" },
}
