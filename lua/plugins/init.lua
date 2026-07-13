-- Plugin specs live in this directory. Each file returns a lazy.nvim spec
-- (a table or a list of tables). This init file returns an empty spec so
-- the `{ import = "plugins" }` in lazy.lua always resolves, even before you
-- add your first plugin. Add plugins by creating new files here, e.g.:
--   lua/plugins/telescope.lua  ->  return { "nvim-telescope/telescope.nvim" }
return {{
  "romus204/tree-sitter-manager.nvim",
  dependencies = {}, -- tree-sitter CLI must be installed system-wide
  config = function()
    require("tree-sitter-manager").setup({
      auto_install = true
    })
  end,
}}
