vim.env.npm_config_registry = "https://registry.npmjs.org/"

local registry = require("mason-registry")

local servers = {
  "bash-language-server",
  "dockerfile-language-server",
  "emmet-language-server",
  "eslint-lsp",
  --"gopls", -- requires go installation
  "lua-language-server",
  "pyright",
  "tailwindcss-language-server",
  "typescript-language-server",
}

local lsp_names = {
  "bashls",
  "dockerls",
  "emmet_ls",
  "eslint",
  --"gopls",
  "lua_ls",
  "pyright",
  "tailwindcss",
  "ts_ls",
}

local function install(pkg_name)
  local ok, pkg = pcall(registry.get_package, pkg_name)
  if not ok then
    vim.notify("Mason: unknown package '" .. pkg_name .. "'", vim.log.levels.WARN)
    return
  end

  if pkg:is_installed() then
    return -- already installed, nothing to do
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

registry.refresh(function()
  for _, name in ipairs(servers) do
    install(name)
  end
end)

vim.lsp.enable(lsp_names)
