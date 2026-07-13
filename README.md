# nvim-config

My personal Neovim configuration. Lua-based, managed with [lazy.nvim](https://github.com/folke/lazy.nvim), with plugin versions pinned in `lazy-lock.json` for reproducible installs.

## What's inside

- **Plugin manager**: lazy.nvim (auto-bootstraps on first launch)
- **Colorscheme**: rose-pine
- **Fuzzy finding**: telescope.nvim + telescope-fzf-native
- **Syntax**: nvim-treesitter parsers, auto-installed via tree-sitter-manager.nvim
- **LSP**: mason.nvim (auto-installs jdtls, lemminx, java-debug-adapter, java-test, vscode-spring-boot-tools)
- **Completion**: blink.cmp
- **Debugging**: nvim-dap + nvim-dap-ui (Java debug adapter wired through nvim-jdtls)
- **Java**: nvim-jdtls (started per-buffer from a FileType autocmd) + spring-boot.nvim
- **UI**: lualine, bufferline, neo-tree, gitsigns, nvim-autopairs, indent-blankline

## Layout

```
.
├── init.lua                  # entry point, requires lua/bavo
├── lazy-lock.json            # pinned plugin versions
└── lua/
    ├── bavo.lua              # requires config.lazy
    ├── config/
    │   └── lazy.lua          # lazy.nvim bootstrap, leader keys, plugin spec import
    └── plugins/              # one file per plugin (or group)
        ├── init.lua          # treesitter parser manager
        ├── telescope.lua
        ├── theme.lua         # rose-pine
        ├── completion.lua    # blink.cmp
        ├── mason.lua         # LSP/DAP tool installer
        ├── java.lua          # jdtls + spring-boot + lemminx
        ├── dap.lua           # nvim-dap + dap-ui
        └── neotree.lua       # neo-tree, lualine, bufferline, gitsigns, ...
```

## Installation

On a new machine:

```bash
git clone git@github.com:bavodaniels/nvim-config.git
cd nvim-config
./install.sh
```

The script will:

1. Check that `git` and `nvim` (0.11+) are installed
2. Back up any existing `~/.config/nvim` to `~/.config/nvim.backup.<timestamp>`
3. Symlink this repo to `~/.config/nvim` (so edits here take effect immediately)
4. Run a headless `Lazy! restore` to install all plugins at the pinned versions

LSP servers and the Java debug tooling are installed automatically by Mason on first launch.

## Requirements

- Neovim >= 0.11 (the config uses the `vim.lsp.config` API)
- git
- A C compiler and `make` (for treesitter parsers and telescope-fzf-native)
- The [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) — parser auto-install
- [ripgrep](https://github.com/BurntSushi/ripgrep) — telescope live grep
- A [Nerd Font](https://www.nerdfonts.com/) in your terminal — icons
- JDK 17+ — for the Java toolchain (jdtls)
- Node.js — some LSP servers installed by Mason need it

The install script warns about any of these that are missing but won't block on the optional ones.
