return {
	"folke/lazydev.nvim",
	ft = "lua", -- only loads when editing Lua files, no overhead elsewhere
	opts = {
		library = {
			-- Teaches the Lua LSP about nvim-dap-ui's types so you get
			-- proper autocomplete and no false diagnostics when writing
			-- dapui config. Pure dev-time convenience, not needed at runtime.
			{ path = "nvim-dap-ui", mods = { "dapui" } },
		},
	},
}
