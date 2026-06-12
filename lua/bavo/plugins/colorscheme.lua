return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000, -- load before other plugins
    config = function()
      require("rose-pine").setup({
        styles = { italic = false },
      })
      vim.cmd.colorscheme("rose-pine")
    end,
  },
}
