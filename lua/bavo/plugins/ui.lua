return {
  -- Project view / file explorer (IntelliJ "Project" panel)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>tt", "<cmd>Neotree toggle<CR>", desc = "Toggle file tree" },
      { "<C-n>", "<cmd>Neotree toggle<CR>", desc = "Toggle file tree" },
      { "<leader>tf", "<cmd>Neotree reveal<CR>", desc = "Reveal current file in tree" },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = true },
      },
      window = { width = 32 },
    },
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "rose-pine",
        globalstatus = true,
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "filetype" },
      },
    },
  },

  -- Buffer/tab line (IntelliJ editor tabs)
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        offsets = {
          { filetype = "neo-tree", text = "Project", separator = true, text_align = "left" },
        },
      },
    },
  },

  -- Keybinding discovery popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>t", group = "tree/test" },
        { "<leader>b", group = "buffer" },
        { "<leader>e", group = "extract" },
      },
    },
  },

  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc })
        end
        map("]h", gs.next_hunk, "Next git hunk")
        map("[h", gs.prev_hunk, "Previous git hunk")
        map("<leader>gp", gs.preview_hunk, "Preview hunk")
        map("<leader>gb", gs.blame_line, "Blame line")
        map("<leader>gr", gs.reset_hunk, "Reset hunk")
      end,
    },
  },

  -- Auto-close brackets/quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = { scope = { enabled = true } },
  },
}
