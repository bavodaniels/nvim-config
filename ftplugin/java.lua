-- Per-buffer jdtls (Eclipse JDT language server) bootstrap.
-- Runs every time a Java file is opened; jdtls.start_or_attach reuses an
-- existing server for the same project root.

local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
  vim.notify("nvim-jdtls not available yet", vim.log.levels.WARN)
  return
end

local home = os.getenv("HOME")
local mason = vim.fn.stdpath("data") .. "/mason/packages"

-- ---------------------------------------------------------------------------
-- Locate the jdtls install that Mason provides
-- ---------------------------------------------------------------------------
local jdtls_path = mason .. "/jdtls"
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher == "" then
  vim.notify("jdtls launcher not found - run :MasonInstall jdtls", vim.log.levels.ERROR)
  return
end

-- Pick the platform-specific config dir
local uname = vim.loop.os_uname()
local config_subdir = "config_linux"
if uname.sysname == "Darwin" then
  config_subdir = (uname.machine == "arm64") and "config_mac_arm" or "config_mac"
elseif uname.sysname == "Windows_NT" then
  config_subdir = "config_win"
end
local config_dir = jdtls_path .. "/" .. config_subdir

-- ---------------------------------------------------------------------------
-- Project root + isolated workspace (one data dir per project)
-- ---------------------------------------------------------------------------
local root_markers = {
  ".git",
  "mvnw",
  "gradlew",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
}
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir or root_dir == "" then
  root_dir = vim.fn.getcwd()
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. project_name

-- ---------------------------------------------------------------------------
-- Run jdtls itself on a stable JDK 21 (independent of the project's JDK)
-- ---------------------------------------------------------------------------
local jdtls_runtime = "/Users/bavodaniels/Library/Java/JavaVirtualMachines/corretto-21.0.11/Contents/Home"
local java_bin = jdtls_runtime .. "/bin/java"
if vim.fn.filereadable(java_bin) == 0 then
  java_bin = "java" -- fall back to whatever is on PATH
end

-- JDKs offered to projects via their execution environment name
local runtimes = {
  {
    name = "JavaSE-1.8",
    path = "/Users/bavodaniels/Library/Java/JavaVirtualMachines/azul-1.8.0_442/Contents/Home",
  },
  {
    name = "JavaSE-11",
    path = "/Users/bavodaniels/Library/Java/JavaVirtualMachines/azul-11.0.26/Contents/Home",
  },
  {
    name = "JavaSE-17",
    path = "/Users/bavodaniels/Library/Java/JavaVirtualMachines/corretto-17.0.5/Contents/Home",
  },
  {
    name = "JavaSE-21",
    path = "/Users/bavodaniels/Library/Java/JavaVirtualMachines/corretto-21.0.11/Contents/Home",
    default = true,
  },
}

-- ---------------------------------------------------------------------------
-- Debug + test bundles (java-debug-adapter, java-test) for nvim-dap
-- ---------------------------------------------------------------------------
local bundles = {}
local debug_jar = vim.fn.glob(
  mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
  true
)
if debug_jar ~= "" then
  vim.list_extend(bundles, vim.split(debug_jar, "\n"))
end
local test_jars = vim.fn.glob(mason .. "/java-test/extension/server/*.jar", true)
if test_jars ~= "" then
  vim.list_extend(bundles, vim.split(test_jars, "\n"))
end

-- ---------------------------------------------------------------------------
-- Completion capabilities from blink.cmp
-- ---------------------------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

-- ---------------------------------------------------------------------------
-- jdtls configuration
-- ---------------------------------------------------------------------------
local config = {
  cmd = {
    java_bin,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx2g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher,
    "-configuration", config_dir,
    "-data", workspace_dir,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  init_options = { bundles = bundles },
  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" }, -- decompile .class files
      references = { includeDecompiledSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      format = { enabled = true },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = runtimes,
      },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.mockito.Mockito.*",
          "org.mockito.ArgumentMatchers.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
        importOrder = { "java", "javax", "com", "org" },
      },
      sources = {
        organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
        generateComments = true,
      },
    },
  },
}

-- ---------------------------------------------------------------------------
-- Java-specific keymaps + DAP wiring on attach
-- ---------------------------------------------------------------------------
config.on_attach = function(_, bufnr)
  -- Debugger: discover main classes and enable hot-code-replace
  jdtls.setup_dap({ hotcodereplace = "auto" })
  pcall(require("jdtls.dap").setup_dap_main_class_configs)

  local map = function(keys, fn, desc, mode)
    vim.keymap.set(mode or "n", keys, fn, { buffer = bufnr, desc = "Java: " .. desc })
  end

  map("<leader>oi", jdtls.organize_imports, "Organize imports")       -- IntelliJ Ctrl+Alt+O
  map("<leader>ev", jdtls.extract_variable, "Extract variable")
  map("<leader>ec", jdtls.extract_constant, "Extract constant")
  map("<leader>em", function() jdtls.extract_method(true) end, "Extract method", "v")
  map("<leader>ev", function() jdtls.extract_variable(true) end, "Extract variable", "v")

  -- Run tests (IntelliJ Ctrl+Shift+F10 vibes)
  map("<leader>tc", jdtls.test_class, "Run test class")
  map("<leader>tn", jdtls.test_nearest_method, "Run nearest test method")
end

jdtls.start_or_attach(config)
