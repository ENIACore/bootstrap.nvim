-- No longer necessary due to nvim.lsp.config()
-- Utilized purely for :LspInstall command
return {
	"mason-org/mason-lspconfig.nvim",
	opts = {},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	}
}
