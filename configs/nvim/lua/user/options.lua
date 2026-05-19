-- ~/.config/nvim/lua/user/options.lua

local opt = vim.opt

-- Line Numbers
opt.relativenumber = true -- Show relative line numbers
opt.number = true         -- Show the absolute line number on the current line

-- Tabs & Indentation
opt.tabstop = 4           -- Number of spaces that a <Tab> counts for
opt.shiftwidth = 4        -- Number of spaces to use for autoindent
opt.expandtab = true      -- Use spaces instead of tabs
opt.autoindent = true     -- Copy indent from current line when starting a new one

-- Search
opt.ignorecase = true     -- Case insensitive search
opt.smartcase = true      -- ...unless you type a capital letter
opt.hlsearch = true       -- Highlight all matches on previous search
opt.incsearch = true      -- Show search matches as you type

-- Appearance
opt.termguicolors = true  -- Enable 24-bit RGB color in the TUI
opt.signcolumn = "yes"    -- Always show the sign column (prevents text shifting)
opt.wrap = false          -- Disable line wrapping (often better for code)

-- System Clipboard
-- Allows you to copy/paste between Neovim and other apps
opt.clipboard:append("unnamedplus")

-- Split Windows
opt.splitright = true     -- Split vertical windows to the right
opt.splitbelow = true     -- Split horizontal windows to the bottom

-- Undo
opt.undofile = true       -- Save undo history to a file (undo persists after closing!)
