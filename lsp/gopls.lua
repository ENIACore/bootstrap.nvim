local capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach_remap = require("utils.lsp").on_attach_remap

return {
	cmd = { "gopls" },
	capabilities = capabilities,
	on_attach = on_attach_remap,
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
}
