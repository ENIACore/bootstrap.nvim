-- Ensures correct node version is always read by neovim, necessary when using nvm which is not detectable by neovim
local function check_node()
	local bins = { "node", "npm", "npx" }
	local missing = {}

	for _, bin in ipairs(bins) do
		if vim.fn.executable("/usr/local/bin/" .. bin) == 0 then
			table.insert(missing, bin)
			vim.notify(bin .. " not found on path at /usr/local/bin", vim.log.levels.WARN)
			vim.notify(
				'Run the command "sudo ln -sf $(which ' .. bin .. ') /usr/local/bin/"' .. bin,
				vim.log.levels.WARN
			)
		end
	end
end

check_node()
