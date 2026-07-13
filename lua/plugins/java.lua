return {
  -- Java LSP / DAP via nvim-jdtls. This is NOT a `setup()`-style plugin: it
  -- must be started per-buffer with the correct project root, so we do that
  -- from a FileType autocmd instead of a lazy `opts` table.
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local home = os.getenv("HOME")
      local mason_jdtls = home .. "/.local/share/nvim/mason/bin/jdtls"

      -- The Java debug adapter ships as jdtls "bundles" (extra jars jdtls loads
      -- at startup). Point at the jar Mason installed for java-debug-adapter.
      local mason_packages = home .. "/.local/share/nvim/mason/packages"
      local bundles = vim.fn.glob(
        mason_packages .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
        true, true
      )

      -- java-test lets jdtls run/debug JUnit tests. Only the test *plugin* jar is
      -- a valid jdtls bundle -- the bundled junit/jacoco jars are runtime deps
      -- the test runner loads itself, and registering them as OSGi bundles errors.
      vim.list_extend(bundles, vim.fn.glob(
        mason_packages .. "/java-test/extension/server/com.microsoft.java.test.plugin-*.jar",
        true, true
      ))

      -- Spring Boot Tools ships extra jdtls bundles (Spring symbols, live bean
      -- hovers, @-annotation navigation inside Java files). spring-boot.nvim
      -- resolves their paths from the Mason package for us. Requiring it here
      -- triggers the lazy-loaded plugin so its bundles are ready before startup.
      vim.list_extend(bundles, require("spring_boot").java_extensions())

      local function start_jdtls()
        local jdtls = require("jdtls")

        local root_dir = vim.fs.root(0, {
          "gradlew", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts", ".git",
        })
        if not root_dir then
          root_dir = vim.fn.getcwd()
        end

        -- A dedicated workspace directory per project keeps jdtls metadata
        -- out of the project folder.
        local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
        local workspace = home .. "/.cache/jdtls/workspace/" .. project_name

        -- Advertise blink.cmp's completion capabilities so jdtls sends rich
        -- completion items (auto-imports, snippet placeholders, resolve data).
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        jdtls.start_or_attach({
          capabilities = capabilities,
          cmd = {
            mason_jdtls,
            "-data", workspace,
            "--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false",
            "--jvm-arg=-Xmx8G",
          },
          root_dir = root_dir,
          -- Hand the debug-adapter jar(s) to jdtls so it can act as a DAP server.
          init_options = {
            bundles = bundles,
          },
          -- Runs once jdtls has attached to the buffer. setup_dap() registers the
          -- Java debug adapter AND a lazy config provider (dap.providers.configs)
          -- that resolves main classes on demand when you press <F9> -- by which
          -- point the project is imported, so a @SpringBootApplication main is
          -- found. Do NOT also call setup_dap_main_class_configs() here: it
          -- *deletes* that lazy provider and eagerly fetches configs at attach
          -- time, before the project is imported (0 main classes found), leaving
          -- dap.configurations.java empty -> "No configuration found for java".
          on_attach = function()
            require("jdtls").setup_dap({ hotcodereplace = "auto" })
          end,
          settings = {
            java = {
              format = {
                enabled = true,
                comments = { enabled = false },
                tabSize = 4,
              },
            },
          },
        })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = start_jdtls,
      })

      -- The plugin was lazy-loaded by the current java buffer's FileType
      -- event, so fire it once for that buffer too.
      if vim.bo.filetype == "java" then
        start_jdtls()
      end
    end,
  },

  -- Spring Boot support. Two parts: (1) a language server for
  -- application.properties/.yml (completion + validation of config keys),
  -- started here for those filetypes; (2) jdtls "extension" bundles that add
  -- Spring-aware features inside Java files -- those are pulled into jdtls via
  -- `java_extensions()` in the nvim-jdtls config above. `opts = {}` makes lazy
  -- call require("spring_boot").setup({}). Needs the vscode-spring-boot-tools
  -- Mason package (installed via mason.lua's ensure_installed).
  {
    "JavaHello/spring-boot.nvim",
    ft = { "java", "yaml", "jproperties" },
    dependencies = { "mfussenegger/nvim-jdtls" },
    opts = {},
  },

  -- XML/XSLT language server (lemminx). nvim-lspconfig on Neovim 0.11+ uses
  -- the vim.lsp.config API rather than `require("lspconfig").<server>.setup`.
  {
    "neovim/nvim-lspconfig",
    ft = { "xml", "xsl", "xslt", "svg" },
    config = function()
      local mason_lemminx = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/lemminx"

      vim.lsp.config("lemminx", {
        cmd = { mason_lemminx },
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        settings = {
          xml = {
            format = {
              enabled = true,
              splitAttributes = "preserve",
              maxLineWidth = 280,
            },
          },
          xslt = {
            format = {
              enabled = true,
              splitAttributes = "preserve",
              maxLineWidth = 280,
            },
          },
        },
      })

      vim.lsp.enable("lemminx")
    end,
  },
}
