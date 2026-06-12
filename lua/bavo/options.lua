-- General editor options. Loaded before lazy.nvim so leader is set early.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation (4 spaces is the Java convention)
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.wrap = false
opt.splitright = true
opt.splitbelow = true
opt.colorcolumn = "120"

-- Files / undo
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"

-- Behaviour
opt.updatetime = 250          -- snappier LSP/diagnostics/CursorHold
opt.timeoutlen = 400          -- which-key popup delay
opt.completeopt = "menu,menuone,noselect"
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- share clipboard with the OS

-- Nicer diagnostics display (inline + signs + float on hover)
vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
})
