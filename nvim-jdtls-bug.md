nvim-jdtls change signature is currently not supporting generic types like List<Object> due to parsing rules

**Sed to fix error:**

```
sed -i '' 's/line:match("%- (%w+) ([^ ]+) ?(.*)")/line:match("%- ([^ ]+) ([^ ]+) ?(.*)")/' \
  ~/.local/share/nvim/lazy/nvim-jdtls/lua/jdtls.lua
```

## Future PR to nvim-jdtls:

cd ~/.local/share/nvim/lazy/nvim-jdtls
git checkout -b fix/change-signature-generic-new-params
git add lua/jdtls.lua
git commit -m "Fix changeSignature parsing for generic new params"
git remote add fork git@github.com:ENIACore/nvim-jdtls.git
git push -u fork fix/change-signature-generic-new-params

## Suggested PR title & body:

- Title:  `Fix changeSignature parsing for generic new parameters`
- Body: `changeSignature  rejects new params whose type contains  <...>  because the prompt parser only matches  %w+  for the type token. This causes generic types like  List<Object>  to be ignored and the refactor to report ‘Method signature and return type are unchanged. Replace the new-param type matcher with a non-space matcher so generic types parse correctly.`
