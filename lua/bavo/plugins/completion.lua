return {
  {
    "saghen/blink.cmp",
    -- use a tagged release so a prebuilt fuzzy-matcher binary is downloaded
    -- (no Rust toolchain required)
    version = "*",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    opts = {
      -- super-tab: <Tab> accepts the popup / jumps snippets, like IntelliJ.
      -- <CR> also accepts when the menu is open.
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu = {
          border = "rounded",
          draw = { treesitter = { "lsp" } },
        },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
