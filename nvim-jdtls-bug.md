# nvim-jdtls change-signature fixes

The change-signature prompt has two independent bugs:

1. New-parameter parsing originally matched only `%w+` for the type, so generic
   types such as `List<Object>` were rejected.
2. JDT-LS can return an error-only response (`errorMessage`) when it cannot
   prepare the refactor. That response has no `modifier` or `parameters`.
   nvim-jdtls treated it as a successful signature, then errored while
   concatenating `modifier` and again on `#signature.parameters` when the
   prompt buffer was closed. Errors returned by the asynchronous
   `java/getChangeSignatureInfo` request were also raised from its callback.

`nvim-jdtls-fix.patch` fixes both problems. It accepts generic parameter types,
checks the JDT-LS response before opening the prompt, reports server and
request errors with `vim.notify`, and returns without attempting an invalid
refactor.

## Apply to another local install

Copy this config directory's `nvim-jdtls-fix.patch` to the other machine, then
from that machine's nvim-jdtls plugin directory run:

```sh
git apply --check /path/to/nvim-jdtls-fix.patch
git apply /path/to/nvim-jdtls-fix.patch
```

For a lazy.nvim install, the plugin directory is usually
`~/.local/share/nvim/lazy/nvim-jdtls`. The patch targets upstream revision
`6e9d953`; if `git apply --check` fails, do not force it—update nvim-jdtls or
adapt the patch to that version. Restart Neovim after applying.

## Current install

The patch is already applied as an uncommitted edit in
`~/.local/share/nvim/lazy/nvim-jdtls/lua/jdtls.lua`. Applying it again there
will fail because the changes are already present.
