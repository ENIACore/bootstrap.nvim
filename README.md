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

- Implement automated `npm install -g @types/jest @types/node` and basic `tsconfig.json` on node projects if they don't already have it (or add warnign to user when doing `vim .` on project without
- Add ranged formatting
- Add multi page scratchpad for notes etc
- Fix lua scratchpad and rename it to something else
- Add command in jdtls to get detected java version OR also on startup
- Auto install of lsp/linters/formatters often fails on initial startup, include install in script or make installer.lua to cleanly do this
- Refactor and improve `scratchpad.lua`
- Refactor and improve `node.lua`

# Known Issues

### `vue_ls` crashes on startup with "Client vue_ls quit with exit code 1"

**Symptom:** Opening a `.vue` file fails to attach `vue_ls`, and `~/.local/state/nvim/lsp.log` shows:

```
TypeError: Cannot read properties of undefined (reading 'protocol')
    at Object.getLanguageService (.../mason/packages/vue-language-server/node_modules/@vue/language-server/lib/server.js:40:86)
```

**Cause:** The Mason registry's `vue-language-server` package pins `typescript@^7.0.2` as a bundled dependency. `@vue/language-server` (Vue Language Tools / Volar) is built against the classic TypeScript API and expects `ts.server.protocol.CommandTypes` to exist. TypeScript 7 is Microsoft's new native/Go-based rewrite and no longer exposes that `ts.server` namespace, so `@vue/language-server` crashes immediately on startup. `lsp/vue_ls.lua` points `init_options.typescript.tsdk` at that same bundled (broken) `typescript` install, so there's no config fix on our end — it's a bad dependency pin in the upstream Mason package.

**Fix:** Pin a compatible TypeScript 5.x inside the Mason package so `tsdk` resolves to a working install:

```sh
cd ~/.local/share/nvim/mason/packages/vue-language-server
npm install typescript@5.9.3 --save-exact --no-save
```

Then restart Neovim (or run `:LspRestart` on a `.vue` buffer).

**Note:** This lives inside Mason's install directory, so a future `:MasonInstall vue-language-server` / update re-pulls `typescript@^7.0.2` and will reintroduce the crash until the upstream mason-registry package fixes the pin. Rerun the command above if it recurs.

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
**/.prettierrc
EOF
```
