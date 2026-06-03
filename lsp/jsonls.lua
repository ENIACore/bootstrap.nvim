local on_attach_remap = require("utils.lsp").on_attach_remap
local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
	cmd = function(dispatchers, config)
		local cmd = "vscode-json-language-server"
		if (config or {}).root_dir then
			local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
			if vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
		end
		return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
	end,
	filetypes = { "json", "jsonc" },
	init_options = {
		provideFormatter = true,
	},
	root_markers = { ".git" },
	on_attach = on_attach_remap,
	capabilities = capabilities,
}
