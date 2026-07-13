return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
    config = function(_, opts)
      require("mason").setup(opts)

      -- Plain mason.nvim has no `ensure_installed` option (that's a
      -- mason-lspconfig / LazyVim feature), so install what we need here.
      local ensure_installed = {
        "jdtls",
        "lemminx",
        "java-debug-adapter",
        "java-test", -- JUnit run/debug support for jdtls
        "vscode-spring-boot-tools", -- Spring Boot language server + jdtls extensions
      }
      local registry = require("mason-registry")

      local function install_missing()
        for _, name in ipairs(ensure_installed) do
          local ok, pkg = pcall(registry.get_package, name)
          if ok and not pkg:is_installed() then
            pkg:install()
          end
        end
      end

      if registry.refresh then
        registry.refresh(install_missing)
      else
        install_missing()
      end
    end,
  },
}
