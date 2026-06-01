local on_attach_remap = require('utils.lsp').on_attach_remap

return {
  cmd = function(dispatchers, config)
    local cmd = 'tailwindcss-language-server'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
  filetypes = {
    'aspnetcorerazor', 'astro', 'astro-markdown', 'blade', 'clojure',
    'django-html', 'htmldjango', 'edge', 'eelixir', 'elixir', 'ejs', 'erb',
    'eruby', 'gohtml', 'gohtmltmpl', 'haml', 'handlebars', 'hbs', 'html',
    'htmlangular', 'html-eex', 'heex', 'jade', 'leaf', 'liquid', 'markdown',
    'mdx', 'mustache', 'njk', 'nunjucks', 'php', 'razor', 'slim', 'twig',
    'css', 'less', 'postcss', 'sass', 'scss', 'stylus', 'sugarss',
    'javascript', 'javascriptreact', 'reason', 'rescript', 'typescript',
    'typescriptreact', 'vue', 'svelte', 'templ',
  },
  capabilities = vim.tbl_deep_extend('force',
    require('cmp_nvim_lsp').default_capabilities(),
    {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    }
  ),
  on_attach = on_attach_remap,
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidScreen = 'error',
        invalidVariant = 'error',
        invalidConfigPath = 'error',
        invalidTailwindDirective = 'error',
        recommendedVariantOrder = 'warning',
      },
      classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
      includeLanguages = {
        eelixir = 'html-eex',
        elixir = 'phoenix-heex',
        eruby = 'erb',
        heex = 'phoenix-heex',
        htmlangular = 'html',
        templ = 'html',
      },
    },
  },
  before_init = function(_, config)
    config.settings = vim.tbl_deep_extend('keep', config.settings, {
      editor = { tabSize = vim.lsp.util.get_effective_tabstop() },
    })
  end,
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local root_files = {
      'tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.mjs', 'tailwind.config.ts',
      'postcss.config.js', 'postcss.config.cjs', 'postcss.config.mjs', 'postcss.config.ts',
      'theme/static_src/tailwind.config.js', 'theme/static_src/tailwind.config.cjs',
      'theme/static_src/tailwind.config.mjs', 'theme/static_src/tailwind.config.ts',
      'theme/static_src/postcss.config.js',
      '.git',
    }
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local found = vim.fs.find(root_files, { path = fname, upward = true })[1]
    if found then
      on_dir(vim.fs.dirname(found))
    end
  end,
}
