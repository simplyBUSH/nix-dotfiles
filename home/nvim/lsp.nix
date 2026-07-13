{ pkgs, ... }:

{
  programs.neovim = {
    extraPackages = with pkgs; [
      clang-tools
      gcc
      gnumake
      unzip
      curl
      wget
      nodejs
      pyright
      jdt-language-server
      lazygit
    ];

    plugins = with pkgs.vimPlugins; [
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

          -- Hook autopairs into cmp if available
          local ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
          if ok then
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
          end

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
        plugin = nvim-docs-view;
        type = "lua";
        config = ''require("docs-view").setup({ position = "right", width = 60 })'';
      }

      # {
      #   plugin = vimtex;
      #   type = "lua";
      #   config = ''
      #     vim.g.vimtex_compiler_latexmk = {
      #       out_dir = "build",
      #       options = { "-pdf", "-shell-escape", "-verbose",
      #                   "-file-line-error", "-synctex=1", "-interaction=nonstopmode" },
      #     }
      #     vim.g.vimtex_view_method      = "skim"
      #     vim.g.vimtex_view_skim_activate = 0
      #     vim.g.vimtex_fold_enabled     = 0
      #     vim.g.vimtex_quickfix_mode    = 2
      #   '';
      # }

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

    # LSP keymaps and autocmds
    initLua = ''
      local keymap = vim.keymap.set
      local opts   = { noremap = true, silent = true }

      -- Codecompanion
      keymap("n", "<leader>ai", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle AI Chat" })
      keymap("v", "<leader>ai", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle AI Chat (Visual)" })
      keymap("v", "<leader>ae", "<cmd>CodeCompanion<cr>", { desc = "AI Edit (Inline)" })
      keymap("n", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions Palette" })

      -- Telescope LSP pickers
      keymap("n", "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, { desc = "Document symbols" })
      keymap("n", "<leader>fr", function() require("telescope.builtin").lsp_references() end,       { desc = "References" })

      -- Diagnostics
      keymap("n", "<leader>d",  vim.diagnostic.open_float, { desc = "Show diagnostic float" })
      keymap("n", "[d", vim.diagnostic.goto_prev, opts)
      keymap("n", "]d", vim.diagnostic.goto_next, opts)
      keymap("n", "<leader>dt", function()
        local cfg = vim.diagnostic.config()
        vim.diagnostic.config({ virtual_text = not cfg.virtual_text })
      end, { desc = "Toggle diagnostic virtual text" })

      -- Trouble
      keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",               { desc = "Toggle Trouble panel" })
      keymap("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",  { desc = "Trouble: buffer diagnostics" })
      keymap("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>",                   { desc = "Trouble: location list" })
      keymap("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                    { desc = "Trouble: quickfix list" })

      -- LSP navigation
      keymap("n", "gd",          vim.lsp.buf.definition,  { desc = "Go to definition" })
      keymap("n", "gD",          vim.lsp.buf.declaration, { desc = "Go to declaration" })
      keymap("n", "gr",          vim.lsp.buf.references,  { desc = "References" })
      keymap("n", "gi",          vim.lsp.buf.implementation, { desc = "Go to implementation" })
      keymap("n", "K",           vim.lsp.buf.hover,       { desc = "Hover docs" })
      keymap("n", "<leader>rn",  vim.lsp.buf.rename,      { desc = "Smart rename" })
      keymap("n", "<leader>ca",  vim.lsp.buf.code_action, { desc = "Code action" })
      keymap("n", "<leader>f",   vim.lsp.buf.format,      { desc = "Format buffer" })

      -- Format on save for Verilog/SystemVerilog
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern  = { "*.v", "*.sv" },
        callback = function() vim.lsp.buf.format() end,
      })
    '';
  };
}
