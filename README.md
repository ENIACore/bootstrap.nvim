# External dependencies

1. `brew install ripgrep` (fuzzy finder - telescope)
2. `brew install fd` (faster file handling - telescope)
3. `brew install openjdk` (Java 26 for jdtls - nvim-jdtls)

# Bootstrap TODO

- automate Java installations: temurin@8, openjdk@11, temurin@17, openjdk@26
- ensure java homes in `/Library/Java/JavaVirtualMachines/*` via `sudo ln -sfn /opt/homebrew/opt/openjdk@<version>/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-<version>.jdk`
- automate python (3.9), npm (latest), golang installations
- automate `:Copilot setup` command and ensure user checks yes on `Copilot chat in the IDE enabled in GitHub settings`
- automate jshint install via `npm -g install jshint`
- automate global .gitignore file (primarily for jdtls files)

# TODO

- Add copilot chat shortcuts (i.e cce to explain selected text etc)

# References

- All lsp configs can be found at `https://github.com/neovim/nvim-lspconfig/tree/master/lsp`

# Not Possible

- Login to copilot AND copilot chat with enterprise account
