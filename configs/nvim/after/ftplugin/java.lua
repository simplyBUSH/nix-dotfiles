-- This file is auto-sourced by Neovim for every Java buffer.
-- nvim-jdtls gives you: completions, real-time errors, code actions,
-- organize imports, rename, extract variable/method, and more.

local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then return end

-- Mason installs jdtls here on macOS:
local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local equinox_launcher = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

-- Per-project workspace (keeps each project's state separate)
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace    = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. project_name

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.level=ALL",
    "-Xmx4g",                         -- 4 GB heap — M4 can spare it
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", equinox_launcher,
    "-configuration", mason_path .. "/config_mac_arm",   -- ARM mac
    "-data", workspace,
  },

  root_dir = require("jdtls.setup").find_root({ "pom.xml", "build.gradle", ".git" }),

  -- Pass cmp capabilities so completions work
  capabilities = require("cmp_nvim_lsp").default_capabilities(),

  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*", "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
        },
        importOrder = { "java", "javax", "com", "org" },
      },
      sources = {
        organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
      },
      codeGeneration = {
        toString     = { template = "${object.className}{${member.name()}=${member.value}, }" },
        useBlocks    = true,
      },
      format = { enabled = true },
    },
  },

  -- Extra Java-specific keybinds, only active in Java files
  on_attach = function(_, bufnr)
    local o = { noremap = true, silent = true, buffer = bufnr }
    -- Organize imports
    vim.keymap.set("n", "<leader>ji", jdtls.organize_imports,          o)
    -- Extract to variable / method (works in visual too)
    vim.keymap.set("n", "<leader>jv", jdtls.extract_variable,          o)
    vim.keymap.set("v", "<leader>jv", function() jdtls.extract_variable(true) end, o)
    vim.keymap.set("n", "<leader>jm", jdtls.extract_method,            o)
    vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end,   o)
    -- Code action (fix suggestions on the current line)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,         o)
  end,

  init_options = { bundles = {} },
}

jdtls.start_or_attach(config)
