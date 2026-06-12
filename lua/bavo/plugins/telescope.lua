return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.9",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
        },
      })

      local builtin = require("telescope.builtin")
      local map = vim.keymap.set
      -- IntelliJ-ish "Search Everywhere" / navigation
      map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      map("n", "<leader>fg", builtin.live_grep, { desc = "Grep in project" })
      map("n", "<leader>fb", builtin.buffers, { desc = "Open buffers" })
      map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
      map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
      map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics list" })
      map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols (file structure)" })
      map("n", "<leader>fw", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols (Goto Symbol)" })
      map("n", "<leader><leader>", builtin.find_files, { desc = "Find files" })
    end,
  },
}
