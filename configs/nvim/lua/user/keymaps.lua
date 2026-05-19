local keymap = vim.keymap.set
local opts   = { noremap = true, silent = true }
vim.g.mapleader = " "

keymap("n", "<leader>ai", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle AI Chat" })
keymap("v", "<leader>ai", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle AI Chat (Visual)" })
keymap("v", "<leader>ae", "<cmd>CodeCompanion<cr>", { desc = "AI Edit (Inline)" })
keymap("n", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions Palette" })

keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "-", "<cmd>Oil<CR>",                          { desc = "Open file explorer (Oil)" })
keymap("n", "<leader>e", "<cmd>Oil --float<CR>",          { desc = "Float file explorer" })


keymap("n", "<leader>ff", function() require("telescope.builtin").find_files() end,   { desc = "Find files" })
keymap("n", "<leader>fg", function() require("telescope.builtin").live_grep() end,    { desc = "Live grep" })
keymap("n", "<leader>fb", function() require("telescope.builtin").buffers() end,      { desc = "Buffers" })
keymap("n", "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, { desc = "Document symbols" })
keymap("n", "<leader>fr", function() require("telescope.builtin").lsp_references() end,       { desc = "References" })

keymap("n", "<leader>d",  vim.diagnostic.open_float, { desc = "Show diagnostic float" })
keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)
keymap("n", "<leader>dt", function()
  local cfg = vim.diagnostic.config()
  vim.diagnostic.config({ virtual_text = not cfg.virtual_text })
end, { desc = "Toggle diagnostic virtual text" })

keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",               { desc = "Toggle Trouble panel" })
keymap("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",  { desc = "Trouble: buffer diagnostics" })
keymap("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>",                   { desc = "Trouble: location list" })
keymap("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                    { desc = "Trouble: quickfix list" })

keymap("n", "<leader>s", "<cmd>vsplit<CR>")

keymap("n", "gd",          vim.lsp.buf.definition,  { desc = "Go to definition" })
keymap("n", "gD",          vim.lsp.buf.declaration, { desc = "Go to declaration" })
keymap("n", "gr",          vim.lsp.buf.references,  { desc = "References" })
keymap("n", "gi",          vim.lsp.buf.implementation, { desc = "Go to implementation" })
keymap("n", "K",           vim.lsp.buf.hover,       { desc = "Hover docs" })
keymap("n", "<leader>rn",  vim.lsp.buf.rename,      { desc = "Smart rename" })
keymap("n", "<leader>ca",  vim.lsp.buf.code_action, { desc = "Code action" })
keymap("n", "<leader>f",   vim.lsp.buf.format,      { desc = "Format buffer" })

keymap("n", "<S-l>", ":bnext<CR>",   opts)    -- next buffer
keymap("n", "<S-h>", ":bprev<CR>",   opts)    -- prev buffer
keymap("n", "<leader>bd", ":bd<CR>", { desc = "Close buffer" })

keymap("n", "<leader>w",  ":w<CR>",         opts)
keymap("n", "<leader>q",  ":q<CR>",         opts)
keymap("n", "<leader>h",  ":nohlsearch<CR>",opts)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

function _G.set_terminal_keymaps()
  local o = { buffer = 0 }
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], o)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], o)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], o)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], o)
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
