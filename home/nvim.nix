{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [ rust-analyzer ];

    plugins = with pkgs.vimPlugins; [
    
      {
        plugin = nightfox-nvim;
        type = "lua";
        config = ''vim.cmd.colorscheme("carbonfox")'';
      }

      nvim-web-devicons
      plenary-nvim
      
      {
        plugin = oil-nvim;
        type = "lua";
        config = ''
          require("oil").setup({
            default_file_explorer = true,
            view_options = { show_hidden = true },
            keymaps = {
              ["<C-v>"] = "actions.select_vsplit",
              ["<C-s>"] = "actions.select_split",
            },
          })
        '';
      }

      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          require("telescope").setup({
            defaults = { path_display = { "truncate" } },
          })
        '';
      }

      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require("nvim-tree").setup({
            view = { width = 30, side = "left" },
            renderer = { group_empty = true },
            filters = { dotfiles = false },
          })
          vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle File Tree" })
        '';
      }

      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require("gitsigns").setup({
            signs = {
              add          = { text = "▎" },
              change       = { text = "▎" },
              delete       = { text = "" },
              topdelete    = { text = "" },
              changedelete = { text = "▎" },
            },
            on_attach = function(bufnr)
              local gs = package.loaded.gitsigns
              local o  = { buffer = bufnr, noremap = true, silent = true }
              vim.keymap.set("n", "]g", gs.next_hunk,        o)
              vim.keymap.set("n", "[g", gs.prev_hunk,        o)
              vim.keymap.set("n", "<leader>gp", gs.preview_hunk,     o)
              vim.keymap.set("n", "<leader>gr", gs.reset_hunk,       o)
              vim.keymap.set("n", "<leader>gb", gs.blame_line,       o)
            end,
          })
        '';
      }

      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require("nvim-autopairs").setup({})
        '';
      }

      {
        plugin = comment-nvim;
        type = "lua";
        config = ''require("Comment").setup()'';
      }

      {
        plugin = toggleterm-nvim;
        type = "lua";
        config = ''
          require("toggleterm").setup({
            size          = 20,
            open_mapping  = [[<c-\>]],
            direction     = "horizontal",
            shell         = vim.o.shell,
          })
        '';
      }
      
      lualine-nvim

      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local capabilities = require("cmp_nvim_lsp").default_capabilities()

          vim.lsp.config("clangd", { capabilities = capabilities })
          vim.lsp.config("nixd", { capabilities = capabilities })
          vim.lsp.config("rust_analyzer", { capabilities = capabilities })
          vim.lsp.enable({ "clangd", "nixd", "rust_analyzer" })   

          vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
          })

          local o = { noremap = true, silent = true }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, o)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, o)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, o)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, o)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, o)
        '';
      }

      cmp-nvim-lsp
      luasnip
      cmp_luasnip

      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require("cmp")
          cmp.setup({
            snippet = {
              expand = function(args) require("luasnip").lsp_expand(args.body) end,
            },
            mapping = cmp.mapping.preset.insert({
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<CR>"] = cmp.mapping.confirm({ select = true }),
              ["<Tab>"] = cmp.mapping.select_next_item(),
              ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            }),
            sources = {
              { name = "nvim_lsp" },
              { name = "luasnip" },
            },
          })
        '';
      }

      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require("lualine").setup({
            options = { theme = "auto", globalstatus = true },
          })
        '';
      }
    ];

    # Global Options, Keymaps, and Autocmds
    initLua = ''
      local opt = vim.opt
      local keymap = vim.keymap.set
      local opts   = { noremap = true, silent = true }

      opt.relativenumber = true
      opt.number = true
      opt.tabstop = 4
      opt.shiftwidth = 4
      opt.expandtab = true
      opt.autoindent = true
      opt.ignorecase = true
      opt.smartcase = true
      opt.hlsearch = true
      opt.incsearch = true
      opt.termguicolors = true
      opt.signcolumn = "yes"
      opt.wrap = false
      opt.clipboard:append("unnamedplus")
      opt.splitright = true
      opt.splitbelow = true
      opt.undofile = true

      vim.g.mapleader = " "

      keymap("n", "<C-h>", "<C-w>h", opts)
      keymap("n", "<C-j>", "<C-w>j", opts)
      keymap("n", "<C-k>", "<C-w>k", opts)
      keymap("n", "<C-l>", "<C-w>l", opts)

      keymap("n", "-", "<cmd>Oil<CR>",                          { desc = "Open file explorer (Oil)" })
      keymap("n", "<leader>e", "<cmd>Oil --float<CR>",          { desc = "Float file explorer" })

      keymap("n", "<leader>ff", function() require("telescope.builtin").find_files() end,   { desc = "Find files" })
      keymap("n", "<leader>fg", function() require("telescope.builtin").live_grep() end,    { desc = "Live grep" })
      keymap("n", "<leader>fb", function() require("telescope.builtin").buffers() end,      { desc = "Buffers" })

      keymap("n", "<leader>s", "<cmd>vsplit<CR>")

      keymap("n", "<S-l>", ":bnext<CR>",   opts)
      keymap("n", "<S-h>", ":bprev<CR>",   opts)
      keymap("n", "<leader>bd", ":bd<CR>", { desc = "Close buffer" })

      keymap("n", "<leader>w",  ":w<CR>",          opts)
      keymap("n", "<leader>q",  ":q<CR>",          opts)
      keymap("n", "<leader>h",  ":nohlsearch<CR>", opts)
      keymap("v", "<", "<gv", opts)
      keymap("v", ">", ">gv", opts)
      keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
      keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    '';
  };
}
