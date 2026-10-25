-- INFO: completion engine
vim.pack.add({ "https://github.com/saghen/blink.cmp" }, { confirm = false })

require("blink.cmp").setup({
  completion = {
    documentation = {
      auto_show = true,
    },
  },
  sources = {
    default = { "lsp", "blade-nav", "path", "snippets", "buffer" },
    per_filetype = {
      sql = { "snippets", "dadbod", "buffer" },
    },
    -- add vim-dadbod-completion to your completion providers
    providers = {
      dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
      laravel = {
        name = "laravel",
        module = "blink.compat.source",
        score_offset = 95, -- show above lsp
      },
      ["blade-nav"] = {
        name = "blade-nav",
        module = "blade-nav.integrations.blink",
      },
    },
  },

  -- default blink keymaps
  keymap = {
    ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
    ["<C-n>"] = { "select_next", "fallback_to_mappings" },

    ["<CR>"] = { "select_and_accept", "fallback" },
    ["<C-e>"] = { "cancel", "fallback" },
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

    ["<Tab>"] = { "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },

    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },

    ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
  },

  fuzzy = {
    implementation = "lua",
  },
})

-- INFO: lsp server installation and configuration

-- lsp servers we want to use and their configuration
-- see `:h lspconfig-all` for available servers and their settings
local lsp_servers = {
  lua_ls = {
    -- https://luals.github.io/wiki/settings/ | `:h nvim_get_runtime_file`
    Lua = { workspace = { library = vim.api.nvim_get_runtime_file("lua", true) } },
  },
  ts_ls = {},
  svelte = {},
  tailwindcss = {},
  basedpyright = {},
  intelephense = {},
  html = {
    filetypes = { "html", "blade" },
    init_options = {
      configurationSection = { "html", "css", "javascript" },
      embeddedLanguages = {
        css = true,
        javascript = true,
      },
      provideFormatter = true,
    },
  },
}

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig", -- default configs for lsps

  -- NOTE: if you'd rather install the lsps through your OS package manager you
  -- can delete the next three mason-related lines and their setup calls below.
  -- see `:h lsp-quickstart` for more details.
  "https://github.com/mason-org/mason.nvim",                     -- package manager
  "https://github.com/mason-org/mason-lspconfig.nvim",           -- lspconfig bridge
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", -- auto installer
}, { confirm = false })

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
  ensure_installed = vim.tbl_keys(lsp_servers),
})

-- configure each lsp server on the table
-- to check what clients are attached to the current buffer, use
-- `:checkhealth vim.lsp`. to view default lsp keybindings, use `:h lsp-defaults`.
for server, config in pairs(lsp_servers) do
  vim.lsp.config(server, {
    settings = config,

    -- only create the keymaps if the server attaches successfully
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "vim.lsp.buf.definition()" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "vim.lsp.buf.hover()" })
      vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { buffer = bufnr })
    end,
  })
end

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup("ThePrimeagen", {})

local autocmd = vim.api.nvim_create_autocmd

function R(name)
  require("plenary.reload").reload_module(name)
end

autocmd({ "BufWritePre" }, {
  group = ThePrimeagenGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = ThePrimeagenGroup,
  callback = function(e)
    local opts = { buffer = e.buf }
    vim.keymap.set("n", "<leader>vd", function()
      vim.diagnostic.open_float()
    end, opts)
    vim.keymap.set("n", "<leader>vca", function()
      vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set("n", "<leader>vrr", function()
      vim.lsp.buf.references()
    end, opts)
    vim.keymap.set("n", "<leader>vrn", function()
      vim.lsp.buf.rename()
    end, opts)
    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, opts)
  end,
})

-- autoformat
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, async = false })
        end,
      })
    end
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Force snippet support capability so Intelephense populates completion lists
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.enable("ruff")

vim.lsp.config("intelephense", {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php", "blade" },
  root_markers = { "composer.json", ".git" },
  settings = {
    intelephense = {
      environment = {
        includePaths = { "app", "routes", "resources/views" },
      },
      files = {
        associations = { "*.php", "*.blade.php" },
        maxSize = 5000000,
      },
    },
  },
  capabilities = capabilities,
  get_language_id = function(bufnr, filetype)
    if filetype == "blade" then
      return "php"
    end
    return filetype
  end,
  on_new_config = function(new_config, new_root_dir)
    new_config.settings.intelephense.files.associations = { "*.php", "*.blade.php" }
  end,
  handlers = {
    ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
      -- Mask the URI/language dynamically so Intelephense processes it
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if client and client.name == "intelephense" then
        -- This forces the server communication to map back smoothly
        ctx.params = ctx.params or {}
      end
      vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
    end,
  },
})

vim.lsp.config("html", {
  filetypes = { "html", "blade", "php" },
  init_options = { provideFormatter = true },
})

vim.lsp.config("laravel_lsp", {
  cmd = { "laravel-lsp" },
  filetypes = { "php", "blade" },
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, "artisan")

    if root then
      on_dir(root)
    end
  end,
})

vim.lsp.enable("laravel_lsp")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_native_completion", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
    end
  end,
})
