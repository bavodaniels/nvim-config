return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "java",
          "lua",
          "vim",
          "vimdoc",
          "bash",
          "json",
          "yaml",
          "xml",
          "markdown",
          "markdown_inline",
          "gitignore",
          "properties",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
