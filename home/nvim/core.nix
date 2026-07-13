{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [
      ripgrep
      fd
      git
      fzf
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = nightfox-nvim;
        type = "lua";
        config = ''vim.cmd.colorscheme("nordfox")'';
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
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require("lualine").setup({
            options = {
              theme                = "auto",
              component_separators = "|",
              section_separators   = "",
            },
            sections = {
              lualine_c = { { "filename", path = 1 } },
              lualine_x = {
                {
                  function()
                    local e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                    local w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                    return (e > 0 and (" " .. e .. " ") or "") ..
                           (w > 0 and (" " .. w) or "")
                  end,
                },
                "encoding", "fileformat", "filetype",
              },
              lualine_y = {
                {
                  function() return "▶ Run" end,
                  on_click = function() _G.compile_and_run() end,
                  color = { fg = "#a3be8c", gui = "bold" },
                },
              },
            },
          })
        '';
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
    ];

    # Global Options, Keymaps, and Autocmds
    initLua = ''
      local opt = vim.opt
      local keymap = vim.keymap.set
      local opts   = { noremap = true, silent = true }

      local function compile_and_run()
        local ft   = vim.bo.filetype
        local file = vim.fn.expand("%:p")
        local name = vim.fn.expand("%:t:r")
        local dir  = vim.fn.expand("%:p:h")

        local cmds = {
          cpp        = ("cd %s && g++ -std=c++17 -Wall -o /tmp/%s %s && /tmp/%s"):format(dir, name, file, name),
          c          = ("cd %s && gcc -Wall -o /tmp/%s %s && /tmp/%s"):format(dir, name, file, name),
          python     = ("python3 %s"):format(file),
          java       = ("cd %s && javac %s && java -cp %s %s"):format(dir, vim.fn.expand("%:t"), dir, name),
          javascript = ("node %s"):format(file),
          lua        = ("lua %s"):format(file),
          tex        = "echo 'Use <leader>ll for VimTeX compilation'",
        }

        local cmd = cmds[ft]
        if not cmd then
          vim.notify("  No run config for filetype: " .. ft, vim.log.levels.WARN)
          return
        end

        vim.cmd("silent! w")

        vim.cmd("1TermExec cmd=" .. vim.fn.shellescape(cmd))
      end
      _G.compile_and_run = compile_and_run

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

      keymap("n", "<F5>",       compile_and_run, { desc = "Compile & Run" })
      keymap("n", "<leader>r",  compile_and_run, { desc = "Compile & Run" })

      function _G.set_terminal_keymaps()
        local o = { buffer = 0 }
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], o)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], o)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], o)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], o)
      end
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    '';
  };
}
