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
      clang-tools
      git
      gcc
      gnumake
      unzip
      curl
      wget
      nodejs
      fzf
      pyright
      jdt-language-server
      texlive.combined.scheme-full
      lazygit
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

      luasnip
      cmp_luasnip
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      friendly-snippets
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require("cmp")
          local luasnip = require("luasnip")
          require("luasnip.loaders.from_vscode").lazy_load()

          cmp.setup({
            snippet = {
              expand = function(args) luasnip.lsp_expand(args.body) end,
            },
            mapping = cmp.mapping.preset.insert({
              ["<C-k>"]     = cmp.mapping.select_prev_item(),
              ["<C-j>"]     = cmp.mapping.select_next_item(),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"]     = cmp.mapping.abort(),
              ["<CR>"]      = cmp.mapping.confirm({ select = true }),
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                else fallback() end
              end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "luasnip" },
              { name = "buffer" },
              { name = "path" },
            }),
            window = {
              completion    = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
            },
          })
        '';
      }

{
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local capabilities = require("cmp_nvim_lsp").default_capabilities()

          vim.lsp.config("pyright", {
            capabilities = capabilities,
            cmd          = { "pyright-langserver", "--stdio" },
            filetypes    = { "python" },
            root_markers = { ".git", "pyproject.toml", "setup.py", ".python-version" },
          })
          vim.lsp.enable("pyright")

          vim.lsp.config("clangd", {
            capabilities = capabilities,
            cmd          = { "clangd", "--background-index" },
            filetypes    = { "c", "cpp", "objc", "objcpp" },
            root_markers = { ".git", "compile_commands.json" },
          })
          vim.lsp.enable("clangd")

          vim.diagnostic.config({
            virtual_text   = { prefix = "●", source = "if_many" },
            signs          = true,
            underline      = true,
            update_in_insert = true,
            severity_sort  = true,
            float = {
              border = "rounded",
              source = "always",
            },
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
        plugin = nvim-jdtls;
        type = "lua";
        config = ''
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
              require("jdtls").start_or_attach({
                cmd = { "jdtls" }, -- Nixpkgs provides this brilliant wrapper automatically
                root_dir = require("jdtls.setup").find_root({".git", "mvnw", "gradlew"}),
              })
            end,
          })
        '';
      }

      {
        plugin = trouble-nvim;
        type = "lua";
        config = ''require("trouble").setup({ use_diagnostic_signs = true })'';
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
          local autopairs = require("nvim-autopairs")
          autopairs.setup({})
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
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

      {
        plugin = nvim-docs-view;
        type = "lua";
        config = ''require("docs-view").setup({ position = "right", width = 60 })'';
      }

      {
        plugin = vimtex;
        type = "lua";
        config = ''
          vim.g.vimtex_compiler_latexmk = {
            out_dir = "build",
            options = { "-pdf", "-shell-escape", "-verbose",
                        "-file-line-error", "-synctex=1", "-interaction=nonstopmode" },
          }
          vim.g.vimtex_view_method      = "skim"
          vim.g.vimtex_view_skim_activate = 0
          vim.g.vimtex_fold_enabled     = 0
          vim.g.vimtex_quickfix_mode    = 2
        '';
      }

      {
        plugin = codecompanion-nvim;
        type = "lua";
        config = ''
          require("codecompanion").setup({
            strategies = {
              chat = { adapter = "ollama" },
              inline = { adapter = "ollama" },
              agent = { adapter = "ollama" },
            },
            adapters = {
              ollama = function()
                return require("codecompanion.adapters").extend("ollama", {
                  schema = {
                    model = {
                      default = "qwen3.5-coder:4b",
                    },
                  },
                })
              end,
            },
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
      
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern  = { "*.v", "*.sv" },
        callback = function() vim.lsp.buf.format() end,
      })
    '';
  };
}
