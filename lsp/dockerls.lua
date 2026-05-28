local on_attach_remap = require('utils.lsp').on_attach_remap

return {
  cmd = { 'docker-langserver', '--stdio' },
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = on_attach_remap,
  filetypes = { 'dockerfile' },
  root_markers = { 'Dockerfile' },
}
