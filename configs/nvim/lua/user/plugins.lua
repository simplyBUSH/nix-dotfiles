local status_ok, lazy = pcall(require, "lazy")
if not status_ok then return end

lazy.setup({

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "lalitmee/codecompanion-spinners.nvim",
    },
    config = function()
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
        extensions = {
          spinner = {
            enabled = true,
            style = "cursor-relative",
          },
        },
      })
    end,
  },

  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nordfox")
    end,
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        view_options = { show_hidden = true },
        keymaps = {
          ["<C-v>"] = "actions.select_vsplit",
          ["<C-s>"] = "actions.select_split",
        },
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = { path_display = { "truncate" } },
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
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
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright" },
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("pyright", {
        capabilities = capabilities,
        cmd          = { "pyright-langserver", "--stdio" },
        filetypes    = { "python" },
        root_markers = { ".git", "pyproject.toml", "setup.py", ".python-version" },
      })
      vim.lsp.enable("pyright")

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
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({ use_diagnostic_signs = true })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
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
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({})
      
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function() require("Comment").setup() end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
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
        },
      })
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size          = 20,
        open_mapping  = [[<c-\>]],
        direction     = "horizontal",
        shell         = vim.o.shell,
      })
    end,
  },

  {
    "amrbashir/nvim-docs-view",
    lazy = true,
    cmd  = "DocsViewToggle",
    config = function()
      require("docs-view").setup({ position = "right", width = 60 })
    end,
  },

  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "build",
        options = { "-pdf", "-shell-escape", "-verbose",
                    "-file-line-error", "-synctex=1", "-interaction=nonstopmode" },
      }
      vim.g.vimtex_view_method      = "skim"
      vim.g.vimtex_view_skim_activate = 0
      vim.g.vimtex_fold_enabled     = 0
      vim.g.vimtex_quickfix_mode    = 2
    end,
  },
})
