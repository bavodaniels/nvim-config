-- Autocompletion popup. blink.cmp shows LSP-provided candidates (e.g. `out`,
-- `in`, `err` after typing `System.`) in a dropdown as you type. It ships a
-- prebuilt Rust fuzzy matcher, so there's no build step on a tagged release.
return {
  "saghen/blink.cmp",
  version = "*", -- use a release tag so the prebuilt binary is downloaded
  event = "InsertEnter",
  ---@module 'blink.cmp'
  opts = {
    -- Default preset, but <Tab> accepts the highlighted item:
    --   <Tab> accept (falls back to normal Tab when the menu is closed)
    --   <C-space> open / toggle docs   <C-e> hide
    --   <Up>/<Down> or <C-p>/<C-n> select
    keymap = {
      preset = "default",
      ["<Tab>"] = { "accept", "fallback" },
    },

    completion = {
      -- Auto-show the documentation window for the highlighted item.
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      -- Preselect + insert the top match as you type (remove if intrusive).
      list = { selection = { preselect = true, auto_insert = false } },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
