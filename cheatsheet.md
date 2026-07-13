# Neovim Cheatsheet

Leader key: `Space`  |  Local leader: `\`

This lists the keymaps **this config actually defines**, plus the relevant
Neovim built-in defaults (clearly marked). The config itself sets no window,
buffer-movement, editing, or LSP keymaps — those come from Neovim's defaults.

---

## File Tree (Neo-tree)

| Key | Action |
|-----|--------|
| `Ctrl+n` | Toggle file tree |
| `<leader>tt` | Toggle file tree |
| `<leader>tf` | Reveal current file in tree |

---

## Buffers / Editor tabs (bufferline)

| Key | Action |
|-----|--------|
| `Shift+Right` | Next buffer |
| `Shift+Left` | Previous buffer |
| `Shift+q` | Close (delete) buffer |

---

## Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in project) |
| `<leader>fb` | List open buffers |
| `<leader>fh` | Help tags |

---

## Completion (blink.cmp — default preset, `Tab` accepts)

| Key | Action |
|-----|--------|
| `Tab` | Accept highlighted item (falls back to normal Tab when menu is closed) |
| `Ctrl+y` | Accept highlighted item |
| `Shift+Tab` | Jump to previous snippet placeholder |
| `Ctrl+Space` | Show menu / toggle documentation |
| `Ctrl+e` | Hide completion menu |
| `Up` / `Down` | Select previous / next item |
| `Ctrl+p` / `Ctrl+n` | Select previous / next item |
| `Ctrl+b` / `Ctrl+f` | Scroll documentation up / down |

Documentation for the highlighted item auto-shows after ~200 ms.

---

## LSP — Neovim built-in defaults

The config configures the servers (jdtls, lemminx, spring-boot) but defines no
LSP keymaps of its own, so these are Neovim's built-in defaults, active once a
language server attaches to the buffer.

| Key | Action | IntelliJ equivalent |
|-----|--------|---------------------|
| `K` | Hover documentation | Quick Doc |
| `grn` | Rename symbol | Shift+F6 |
| `gra` | Code action / quick fix (normal & visual) | Alt+Enter |
| `grr` | Find references | Alt+F7 |
| `gri` | Go to implementation | Cmd+Alt+B |
| `grt` | Go to type definition | — |
| `gO` | Document symbols (file structure) | — |
| `Ctrl+s` *(insert)* | Signature help | — |
| `Ctrl+]` | Go to definition (via tagfunc) | Cmd+B |

### Diagnostics (Neovim defaults)

| Key | Action |
|-----|--------|
| `]d` / `[d` | Next / previous diagnostic |
| `]D` / `[D` | Last / first diagnostic |

There is no keymap for formatting; the language servers format on request
(`:lua vim.lsp.buf.format()`).

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

The debug adapter for Java is wired up by nvim-jdtls; the dap-ui panels open
automatically when a session starts and close when it ends.

### Workflow (Java)

1. Open a `.java` file and wait for jdtls to attach.
2. Set a breakpoint on the target line with `<leader>b`.
3. Press `F9` to start — a picker lists the discovered main classes.
4. Select a class to launch; the debug UI opens automatically.
5. Step through with the keys below; `F9` again continues to the next breakpoint.
6. `<leader>dt` terminates (or let the program exit — the UI closes itself).

### Keymaps

| Key | Action |
|-----|--------|
| `<leader>b` | Toggle breakpoint |
| `<leader>bl` | Set logpoint (prints a message instead of pausing) |
| `F9` | Start / continue |
| `F8` | Step over |
| `F12` | Step out |
| `<leader>dr` | Open REPL |
| `<leader>dt` | Terminate session |
| `<leader>dh` | Hover value under cursor (normal & visual) |
| `<leader>du` | Toggle debug UI |

> **Note:** step-into is mapped to `<F>` in `lua/plugins/dap.lua`, which is not a
> valid key notation (likely a typo for `<F7>`), so step-into currently has no
> working binding. Use `:lua require('dap').step_into()` until it's fixed.

Breakpoint signs: `●` (breakpoint), `▶` (current stopped line).

---

## Running the application

There is no dedicated "run" binding; use the built-in terminal.

| Key / Command | Action |
|---------------|--------|
| `:terminal` | Open a terminal buffer in the current window |
| `:split \| terminal` | Open a terminal in a horizontal split |
| `Ctrl+\ Ctrl+n` | Exit terminal insert mode → normal mode |

Common build-tool commands to type inside the terminal:

```
mvn spring-boot:run          # Maven Spring Boot
./gradlew bootRun            # Gradle Spring Boot
./gradlew run                # Gradle application plugin
java -jar target/app.jar     # Plain executable jar
```

---

## Editing

Brackets and quotes are auto-closed by nvim-autopairs. Indentation guides are
drawn by indent-blankline (the current scope is highlighted).

No custom editing keymaps are defined — standard Vim motions apply.
