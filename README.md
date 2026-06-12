# nvim-config

My personal Neovim configuration. Lua-based, managed with [lazy.nvim](https://github.com/folke/lazy.nvim), with plugin versions pinned in `lazy-lock.json` for reproducible installs.

## What's inside

- **Plugin manager**: lazy.nvim (auto-bootstraps on first launch)
- **Colorscheme**: rose-pine
- **Fuzzy finding**: telescope.nvim
- **Syntax**: nvim-treesitter
- **LSP**: nvim-lspconfig + mason.nvim (auto-installs servers: jdtls, lua-language-server, stylua, ...)
- **Completion**: blink.cmp + friendly-snippets
- **Debugging**: nvim-dap + nvim-dap-ui (Java debug adapter via Mason)
- **Java**: nvim-jdtls with dedicated `ftplugin/java.lua` setup
- **UI**: lualine, bufferline, neo-tree, gitsigns, which-key, indent-blankline

## Layout

```
.
├── init.lua                  # entry point, requires lua/bavo
├── lazy-lock.json            # pinned plugin versions
├── ftplugin/
│   └── java.lua              # jdtls per-buffer setup
└── lua/bavo/
    ├── init.lua              # loads options, keymaps, lazy
    ├── options.lua
    ├── keymaps.lua
    ├── lazy.lua              # lazy.nvim bootstrap + plugin spec import
    └── plugins/              # one file per plugin (or group)
```

## Installation

On a new machine:

```bash
git clone git@github.com:bavodaniels/nvim-config.git
cd nvim-config
./install.sh
```

The script will:

1. Check that `git` and `nvim` (0.10+) are installed
2. Back up any existing `~/.config/nvim` to `~/.config/nvim.backup.<timestamp>`
3. Symlink this repo to `~/.config/nvim` (so edits here take effect immediately)
4. Run a headless `Lazy! restore` to install all plugins at the pinned versions

LSP servers and the Java debug tooling are installed automatically by Mason on first launch.

## Requirements

- Neovim >= 0.10
- git
- A C compiler (for treesitter parsers)
- [ripgrep](https://github.com/BurntSushi/ripgrep) — telescope live grep
- A [Nerd Font](https://www.nerdfonts.com/) in your terminal — icons
- JDK 17+ — for the Java toolchain (jdtls)
- Node.js — some LSP servers installed by Mason need it

The install script warns about any of these that are missing but won't block on the optional ones.
