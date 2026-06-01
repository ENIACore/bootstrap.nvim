local M = {}

local registry = require("mason-registry")

M.registry = registry

M.install_pkg = function(self, pkg_name)
	local ok, pkg = pcall(self.registry.get_package, pkg_name)

	if not ok then
		vim.notify("Mason: unknown package '" .. pkg_name .. "'", vim.log.levels.WARN)
		return
	end

	if pkg:is_installed() then
		return
	end

	vim.notify("Mason: installing " .. pkg_name .. "...", vim.log.levels.INFO)
	pkg:install()
		:on("install:success", function()
			vim.notify("Mason: " .. pkg_name .. " installed.", vim.log.levels.INFO)
		end)
		:on("install:failed", function()
			vim.notify("Mason: " .. pkg_name .. " FAILED to install.", vim.log.levels.ERROR)
		end)
end

M.install_pkg_list = function(self, pkg_name_list)
	for _, pkg_name in ipairs(pkg_name_list) do
		self:install_pkg(pkg_name)
	end
end

M.get_pkg_path = function(self, pkg_name)
	local ok, pkg = pcall(self.registry.get_package, pkg_name)

	if not ok then
		vim.notify("Mason: unknown package '" .. pkg_name .. "'", vim.log.levels.WARN)
		return nil
	end

	if not pkg:is_installed() then
		vim.notify("Mason: package is not installed '" .. pkg_name .. "'", vim.log.levels.WARN)
		return nil
	end

	return pkg:get_install_path()
end

return M
