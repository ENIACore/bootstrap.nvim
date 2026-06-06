local treesitter = require("nvim-treesitter")

treesitter.setup({
	-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
	install_dir = vim.fn.stdpath("data") .. "/site",
})
treesitter.install({
	"rust", -- no lsp file yet
	"javascript", -- ts_ls.lua
	"typescript", -- ts_ls.lua
	"python", -- pyright.lua
	"lua", -- lua_ls.lua
	"go", -- gopls.lua
	"bash", -- bashls.lua
	"json", -- jsonls.lua
	"markdown", -- marksman.lua
	"html", -- emmet_ls.lua
	"css", -- emmet_ls.lua / tailwindcss.lua
	"tsx", -- ts_ls.lua
	"dockerfile", -- dockerls.lua
})
