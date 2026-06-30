# External dependencies

1. `brew install ripgrep` (fuzzy finder - telescope)
2. `brew install fd` (faster file handling - telescope)
3. `brew install openjdk` (Java 26 for jdtls - nvim-jdtls)

# Bootstrap TODO

- automate `tsconfig.json` setup (contents at bottom)
- automate global `~/.gitignore` setup via `git config --global core.excludesfile ~/.config/nvim/git/.gitignore`
- automate work specific gitconfig and gitignore setup (commands at bottom)
- automate Java installations: temurin@8, openjdk@11, temurin@17, openjdk@26
- ensure java homes in `/Library/Java/JavaVirtualMachines/*` via `sudo ln -sfn /opt/homebrew/opt/openjdk@<version>/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-<version>.jdk`
- automate python (3.9), npm (latest), golang installations
- automate `:Copilot setup` command and ensure user checks yes on `Copilot chat in the IDE enabled in GitHub settings`
- automate jshint install via `npm -g install jshint`
- automate global .gitignore file (primarily for jdtls files)
- automate installation of shellcheck for bashls
- automate `brew install tree-sitter`

# TODO

- Implement automated `npm install @types/jest @types/node` and basic `tsconfig.json` on node projects if they don't already have it (or add warnign to user when doing `vim .` on project without
- Add ranged formatting
- Add multi page scratchpad for notes etc
- Fix lua scratchpad and rename it to something else
- Add command in jdtls to get detected java version OR also on startup
- Auto install of lsp/linters/formatters often fails on initial startup, include install in script or make installer.lua to cleanly do this
- Refactor and improve `scratchpad.lua`
- Refactor and improve `node.lua`

# References

- All lsp configs can be found at `https://github.com/neovim/nvim-lspconfig/tree/master/lsp`

# Not Possible

- Login to copilot AND copilot chat with enterprise account

### tsconfig.json

```
{
  "compilerOptions": {
    "checkJs": false,
    "noEmit": true,
    "types": ["jest", "node"]
  },
  "exclude": ["**/node_modules/**"]
}
```

### work gitconfig setup

```
git config -f ~/work/.gitconfig core.excludesfile ~/work/.gitignore # Add work specifc gitconfig that uses work specific gitignore
git config --global includeIf.gitdir:~/work/.path ~/work/.gitconfig # Tell global gitconfig to use work gitconfig if inside ~/work
# Create work gitignore based on global gitignore
cat ~/.config/nvim/git/.gitignore > ~/work/.gitignore
# Add work specific gitignore settings
cat >> ~/work/.gitignore << 'EOF'

# Project-specific scripts
scripts/test-skip-known-failures.sh

# Build artifacts / generated config
**/babel.config.js
**/tsconfig.json
EOF
```
