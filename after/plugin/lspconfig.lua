-- Set up lspconfig
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach_remap = require('utils.lsp').on_attach_remap

--[[
Enables lua error checking (primarily for neovim code)
--]]
vim.lsp.config('lua_ls', {
	capabilities = capabilities,
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
    		if
        		path ~= vim.fn.stdpath('config')
        		and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
    		then
        		return
        	end
    	end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
    			-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
    			version = 'LuaJIT',
    			-- Tell the language server how to find Lua modules same way as Neovim (see `:h lua-module-load`)
    			path = {
    				'lua/?.lua',
        			'lua/?/init.lua',
    			},
    		},

    		-- Make the server aware of Neovim runtime files
    		workspace = {
    			checkThirdParty = false,
    			library = {
    				vim.env.VIMRUNTIME
					-- Depending on the usage, you might want to add additional paths, (${3rd}/luv/library etc..)
        		}
    		}
      	})
    end,

	on_attach = on_attach_remap,

    settings = {
		Lua = {}
    }
})


--[[
Enables python error checking
--]]
vim.lsp.config('pyright', {
  capabilities = capabilities,
  on_attach = on_attach_remap,

  settings = {
      python = {
          pythonPath = vim.fn.getcwd() .. "/env/bin/python3",
          analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true
          }
      }
  }
})


--[[
Enables general js error checking
--]]
vim.lsp.enable('eslint')
local base_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config("eslint", {
  capabilities = capabilities, -- Don't forget this!
  on_attach = function(client, bufnr)
    -- Call custom keybindings
    on_attach_remap(client, bufnr)
    -- Call the base eslint on_attach if it exists
    if base_on_attach then
      base_on_attach(client, bufnr)
    end
    -- Add auto-fix on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "LspEslintFixAll",
    })
  end,
})

--[[
Enables tailwind css checking (primarily used for html class tyles)
--]]
vim.lsp.enable('tailwindcss')
vim.lsp.config('tailwindcss', {
    on_attach = on_attach_remap,
    settings = {
        tailwindCSS = {
            classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
            includeLanguages = {
                eelixir = "html-eex",
                elixir = "phoenix-heex",
                eruby = "erb",
                heex = "phoenix-heex",
                htmlangular = "html",
                templ = "html"
            },
            lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning"
            },
            validate = true
        }
    },
    workspace_required = true

})

--[[
Enables typescript error checking
--]]
vim.lsp.enable('ts_ls')
vim.lsp.config('ts_ls', {
    on_attach = on_attach_remap
})

--[[
Enables html auto complete
Example, type h1 and press enter
--]]
vim.lsp.enable('emmet_ls')
vim.lsp.config('emmet_ls', {
    on_attach = on_attach_remap
})

vim.lsp.enable('gopls')
vim.lsp.config('gopls', {
    on_attach = on_attach_remap,
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    cmd = { "gopls" }
})

vim.lsp.enable('bashls')
vim.lsp.config('bashls', {
    on_attach = on_attach_remap,
    cmd = { 'bash-language-server', 'start' },
    filetypes = {'bash', 'sh'},
    root_markers = {'.git'},
    settings = {
        bashIde = {
            globPattern = "*@(.sh|.inc|.bash|.command)"
        }
    }
})

vim.lsp.enable('dockerls')
vim.lsp.config('dockerls', {
    cmd = { "docker-langserver", "--stdio" },
    filetypes = { "dockerfile" },
    root_markers = { "Dockerfile" },
})
