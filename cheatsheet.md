# Neovim Cheatsheet

Leader key: `Space`  |  Local leader: `\`

---

## General

| Key | Action |
|-----|--------|
| `<Esc>` | Clear search highlight |
| `<leader>w` | Save file |
| `<leader>q` | Quit window |

---

## Navigation

### Windows
| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Move to window left/down/up/right |
| `Ctrl+Up/Down` | Resize window height |
| `Ctrl+Left/Right` | Resize window width |

### Buffers (tabs)
| Key | Action |
|-----|--------|
| `Shift+l` | Next buffer |
| `Shift+h` | Previous buffer |
| `<leader>bd` | Delete (close) buffer |

### Scrolling
| Key | Action |
|-----|--------|
| `Ctrl+d` | Half-page down (cursor stays centred) |
| `Ctrl+u` | Half-page up (cursor stays centred) |
| `n / N` | Next/previous search match (centred) |

---

## File Tree (Neo-tree)

| Key | Action |
|-----|--------|
| `Ctrl+n` | Toggle file tree |
| `<leader>tt` | Toggle file tree |
| `<leader>tf` | Reveal current file in tree |

---

## Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<leader><leader>` | Find files |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in project) |
| `<leader>fb` | List open buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fd` | Diagnostics list |
| `<leader>fs` | Document symbols (file structure) |
| `<leader>fw` | Workspace symbols |

### Inside Telescope
| Key | Action |
|-----|--------|
| `Ctrl+j/k` | Move up/down in results |
| `Enter` | Open selected |
| `Ctrl+v` | Open in vertical split |
| `Ctrl+x` | Open in horizontal split |
| `Esc` | Close |

---

## LSP (Language Server)

| Key | Action | IntelliJ equivalent |
|-----|--------|---------------------|
| `gd` | Go to definition | Cmd+B |
| `gD` | Go to declaration | — |
| `gr` | Find references | Alt+F7 |
| `gi` | Go to implementation | Cmd+Alt+B |
| `gt` | Go to type definition | — |
| `K` | Hover documentation | Quick Doc |
| `Ctrl+k` *(insert)* | Signature help | — |
| `<leader>rn` | Rename symbol | Shift+F6 |
| `<leader>ca` | Code action / quick fix | Alt+Enter |
| `<leader>cf` | Format buffer | Cmd+Alt+L |
| `<leader>e` | Show line diagnostics | — |
| `[d` | Previous diagnostic | — |
| `]d` | Next diagnostic | — |

---

## Completion (blink.cmp — super-tab preset)

| Key | Action |
|-----|--------|
| `Tab` | Accept suggestion / jump to next snippet placeholder |
| `Shift+Tab` | Jump to previous snippet placeholder |
| `Enter` | Accept suggestion |
| `Ctrl+Space` | Show / toggle documentation |
| `Ctrl+e` | Hide completion menu |

Ghost text is shown inline as you type.

---

## Git (gitsigns)

| Key | Action |
|-----|--------|
| `]h` | Next git hunk |
| `[h` | Previous git hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame current line |
| `<leader>gr` | Reset hunk |

---

## Debugging (nvim-dap)

| Key | Action | IntelliJ equivalent |
|-----|--------|---------------------|
| `F5` | Start / Continue | F5 |
| `F9` | Toggle breakpoint | F9 |
| `F10` | Step over | F8 |
| `F11` | Step into | F7 |
| `F12` | Step out | Shift+F8 |
| `<leader>db` | Toggle breakpoint | — |
| `<leader>dB` | Conditional breakpoint | — |
| `<leader>dc` | Continue | — |
| `<leader>dr` | Toggle REPL | — |
| `<leader>du` | Toggle debug UI | — |
| `<leader>dt` | Terminate session | — |

The debug UI opens and closes automatically when a session starts/ends.

---

## Java-specific (jdtls — active in `.java` files)

| Key | Action | IntelliJ equivalent |
|-----|--------|---------------------|
| `<leader>oi` | Organize imports | Ctrl+Alt+O |
| `<leader>ev` | Extract variable | — |
| `<leader>ec` | Extract constant | — |
| `<leader>em` *(visual)* | Extract method | — |
| `<leader>ev` *(visual)* | Extract variable | — |
| `<leader>tc` | Run test class | Ctrl+Shift+F10 |
| `<leader>tn` | Run nearest test method | Ctrl+Shift+F10 |

---

## Editing

| Key | Action |
|-----|--------|
| `Alt+j` *(visual)* | Move selected lines down |
| `Alt+k` *(visual)* | Move selected lines up |

Brackets and quotes are auto-closed by nvim-autopairs.

---

## which-key

Press `Space` and wait (~400 ms) to see a popup of all available leader bindings grouped by prefix.
