--[[
-- Automatically ensures lsp servers are installed and enabled (configurations found in /lsp folder)
--]]
local registry = require("utils.registry")

local servers = {
	"bash-language-server",
	"dockerfile-language-server",
	"emmet-language-server",
	"eslint-lsp",
	"gopls", -- requires go installation
	"lua-language-server",
	"pyright",
	"python-lsp-server", -- For python docs, not just stubs provided by pyright
	"tailwindcss-language-server",
	"typescript-language-server",
	"marksman",
	"json-lsp",
}

local lsp_names = {
	"bashls",
	"dockerls",
	"emmet_ls",
	"eslint",
	"gopls",
	"lua_ls",
	"pyright",
	"pylsp",
	"tailwindcss",
	"ts_ls",
	"marksman",
	"jsonls",
}

registry:install_pkg_list(servers)
vim.lsp.enable(lsp_names)
