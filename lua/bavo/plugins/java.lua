return {
  -- nvim-jdtls drives the Eclipse JDT language server. The actual
  -- start_or_attach() call lives in ftplugin/java.lua so it runs per project.
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = { "mfussenegger/nvim-dap" },
  },
}
