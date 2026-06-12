return {
  -- Package manager for LSP servers / DAP adapters / formatters
  {
    "mason-org/mason.nvim",
    opts = {
      ui = { border = "rounded" },
    },
  },

  -- Ensure the Java toolchain tools are installed automatically
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "jdtls",               -- Eclipse Java language server
        "java-debug-adapter",  -- DAP adapter for Java
        "java-test",           -- JUnit/TestNG runner bundle
        "lua-language-server",
        "stylua",
      },
      run_on_start = true,
    },
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "mason-org/mason.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Apply blink.cmp completion capabilities to every server by default.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Lua language server (for editing this config)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
        -- jdtls is started by nvim-jdtls (ftplugin/java.lua), not auto-enabled here
        automatic_enable = { exclude = { "jdtls" } },
      })

      -- Shared LSP keymaps, applied when any server attaches (incl. jdtls).
      -- Mappings are modelled on IntelliJ where it makes sense.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("bavo-lsp-attach", { clear = true }),
        callback = function(ev)
          local map = function(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "Go to definition")        -- IntelliJ Cmd+B
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", require("telescope.builtin").lsp_references, "Find references")           -- IntelliJ Alt+F7
          map("gi", require("telescope.builtin").lsp_implementations, "Go to implementation") -- IntelliJ Cmd+Alt+B
          map("gt", require("telescope.builtin").lsp_type_definitions, "Go to type definition")
          map("K", vim.lsp.buf.hover, "Hover documentation")                                  -- IntelliJ Quick Doc
          map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")                              -- IntelliJ Shift+F6
          map("<leader>ca", vim.lsp.buf.code_action, "Code action / quick fix", { "n", "v" }) -- IntelliJ Alt+Enter
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer") -- IntelliJ Cmd+Alt+L
          map("<leader>e", vim.diagnostic.open_float, "Show line diagnostics")
          map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
          map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
        end,
      })
    end,
  },
}
