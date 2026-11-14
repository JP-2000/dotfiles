# AGENTS.md

- This is a personal Neovim Lua config, not a package repo; there is no build/test script or CI config.
- Entrypoint is `init.lua`, which loads `options`, `keymaps`, `autocmds`, then `config.lazy`.
- Plugin specs live in `lua/plugins/*.lua` and are imported by `lua/config/lazy.lua` via lazy.nvim `{ import = "plugins" }`.
- `lazy-lock.json` pins plugin revisions; update it only when intentionally changing/updating plugins.
- Do not treat `.local-history/` as source; it is local state from `vim-local-history`.
- Formatting is configured through conform.nvim: Lua uses `stylua`, Python uses `ruff_format`.
- Python linting uses `ruff`; Python LSP is `pyright` installed through mason-lspconfig.
- Python DAP setup expects a `debugpy-adapter` executable: `require("dap-python").setup("debugpy-adapter")`.
- Treesitter parsers are installed for `lua`, `vim`, `vimdoc`, `query`, `c`, and `python`; `nvim-treesitter` runs `:TSUpdate` on build.
- For a basic startup/plugin-load check after config edits, run `nvim --headless "+Lazy! load all" "+qa"` from this directory.
- If plugin installs/updates are intended, run them through lazy.nvim rather than editing `lazy-lock.json` by hand.
