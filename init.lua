vim.cmd([[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo,dbout nnoremap <silent> <buffer> q :close<CR>
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end

  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=0
  augroup end
]])

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- enable true color support
vim.opt.termguicolors = true

-- make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- replace all instances of current word
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- enable mouse mode, can be useful for resizing splits
vim.opt.mouse = "a"

-- sync clipboard between OS and neovim.
--  remove this option if you want your OS clipboard to remain independent.
--  see `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"

-- save undo history
vim.opt.undofile = true

-- keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- sets how neovim will display certain whitespace characters in the editor.
--  see `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- enable live preview of substitutions
vim.opt.inccommand = "split"

-- show which line your cursor is on
vim.opt.cursorline = true

-- enable break indent
vim.opt.breakindent = true

-- enable line wrapping
vim.opt.wrap = false

-- formatting
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.colorcolumn = "90"

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
  virtual_text = true, -- show inline diagnostics
})

-- clear search highlights with <Esc>
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- INFO: colorscheme

vim.pack.add({ "https://github.com/folke/tokyonight.nvim" }, { confirm = false })

require("tokyonight").setup({
  transparent = true,
  style = "night",
  on_highlights = function(hl, c)
    hl.TelescopeNormal = {
      bg = "none",
      fg = c.fg_dark,
    }
    hl.TelescopeBorder = {
      bg = "none",
      fg = c.fg_dark,
    }
    hl.TelescopePromptNormal = {
      bg = "none",
      fg = c.fg_dark,
    }
    hl.TelescopePromptBorder = {
      bg = "none",
      fg = c.fg_dark,
    }
    hl.TelescopePromptTitle = {
      bg = "none",
      fg = c.fg_dark,
    }
    hl.TelescopePreviewTitle = {
      bg = c.bg_dark,
      fg = c.fg_dark,
    }
    hl.TelescopeResultsTitle = {
      bg = c.bg_dark,
      fg = c.fg_dark,
    }
  end,
})

vim.cmd.colorscheme("tokyonight")
vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })
require("lualine").setup({
  options = {
    { theme = "tokyonight" },
  },
  sections = {
    lualine_c = {
      {
        "filename",
        path = 4,
        shorting_target = 100,
      },
    },
  },
})
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })

-- INFO: plugins
-- we install plugins with neovim's builtin package manager: vim.pack
-- and then enable/configure them by calling their setup functions.
--
-- (see `:h vim.pack` for more details on how it works)
-- you can press `gx` on any of the plugin urls below to open them in your
-- browser and check out their documentation and functionality.
-- alternatively, you can run `:h {plugin-name}` to read their documentation.
--
-- plugins are then loaded and configured with a call to `setup` functions
-- provided by each plugin. this is not a rule of neovim but rather a convention
-- followed by the community.
-- these setup calls take a table as an agument and their expected contents can
-- vary wildly. refer to each plugin's documentation for details.

-- INFO: formatting and syntax highlighting
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" }, { confirm = false })

-- equivalent to :TSUpdate
require("nvim-treesitter.install").update("all")

require("nvim-treesitter.config").setup({
  auto_install = true, -- autoinstall languages that are not installed yet
})

-- INFO: completion engine
vim.pack.add({ "https://github.com/saghen/blink.cmp" }, { confirm = false })

require("blink.cmp").setup({
  completion = {
    documentation = {
      auto_show = true,
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
  clangd = {},
  rust_analyzer = {},
  gopls = {},
  ts_ls = {},
  svelte = {},
  tailwindcss = {},
}

vim.pack.add({
  "https://github.com/MunifTanjim/nui.nvim", -- default configs for lsps
  "https://github.com/folke/noice.nvim",    -- default configs for lsps
})
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    lsp_doc_border = true,
  },
})

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

      vim.keymap.set("n", "vd", vim.diagnostic.open_float, { buffer = bufnr, desc = "vim.diagnostic.open_float" })
    end,
  })
end

-- autoformat
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end
  end,
})

-- INFO: fuzzy finder
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim", -- library dependency
})

vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons", -- icons (nerd font)
})

vim.pack.add({
  "https://github.com/nvim-telescope/telescope.nvim", -- the fuzzy finder
})

require("telescope").setup({})

local pickers = require("telescope.builtin")

vim.keymap.set("n", "<leader>pf", pickers.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>pg", pickers.live_grep, { desc = "[S]earch by [G]rep" })
--

-- autotags
vim.pack.add({ "https://github.com/windwp/nvim-ts-autotag" })
vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })
require("nvim-ts-autotag").setup()
require("nvim-autopairs").setup({})

vim.pack.add({ "https://github.com/folke/todo-comments.nvim" })
require("todo-comments").setup({
  signs = true,     -- show icons in the signs column
  sign_priority = 8, -- sign priority
  -- keywords recognized as todo comments
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  gui_style = {
    fg = "NONE",        -- The gui style to use for the fg highlight group.
    bg = "BOLD",        -- The gui style to use for the bg highlight group.
  },
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults
  -- highlighting of the line containing the todo comment
  -- * before: highlights before the keyword (typically comment characters)
  -- * keyword: highlights of the keyword
  -- * after: highlights after the keyword (todo text)
  highlight = {
    multiline = true,              -- enable multine todo comments
    multiline_pattern = "^.",      -- lua pattern to match the next multiline from the start of the matched keyword
    multiline_context = 10,        -- extra lines that will be re-evaluated when changing a line
    before = "",                   -- "fg" or "bg" or empty
    keyword = "wide",              -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
    after = "fg",                  -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
    comments_only = true,          -- uses treesitter to match keywords in comments only
    max_line_len = 400,            -- ignore lines longer than this
    exclude = {},                  -- list of file types to exclude highlighting
  },
  -- list of named colors where we try to extract the guifg from the
  -- list of highlight groups or use the hex color if hl not found as a fallback
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
    info = { "DiagnosticInfo", "#2563EB" },
    hint = { "DiagnosticHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
    test = { "Identifier", "#FF00FF" },
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  },
})

-- db
vim.pack.add({ "https://github.com/tpope/vim-dadbod" })
vim.pack.add({ "https://github.com/kristijanhusak/vim-dadbod-completion" })
vim.pack.add({ "https://github.com/kristijanhusak/vim-dadbod-ui" })
vim.keymap.set("n", "<leader>d", "<CMD>DBUIToggle<CR>")

vim.pack.add({ "https://github.com/tpope/vim-fugitive" })
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
local my_fugitive = vim.api.nvim_create_augroup("my_fugitive", {})
local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
  group = my_fugitive,
  pattern = "*",
  callback = function()
    if vim.bo.ft ~= "fugitive" then
      return
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2", name = "harpoon" },
})

local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end)
vim.keymap.set("n", "<C-e>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<C-h>", function()
  harpoon:list():select(1)
end)
vim.keymap.set("n", "<C-t>", function()
  harpoon:list():select(2)
end)
vim.keymap.set("n", "<C-n>", function()
  harpoon:list():select(3)
end)
vim.keymap.set("n", "<C-s>", function()
  harpoon:list():select(4)
end)

vim.pack.add({ "https://github.com/rachartier/tiny-inline-diagnostic.nvim" })
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    vim.diagnostic.config({ virtual_text = false })
    require("tiny-inline-diagnostic").setup({
      preset = "powerline", -- Can be: "modern", "classic", "minimal", "powerline", ghost", "simple", "nonerdfont", "amongus"
      hi = {
        error = "DiagnosticError",
        warn = "DiagnosticWarn",
        info = "DiagnosticInfo",
        hint = "DiagnosticHint",
        arrow = "NonText",
        background = "CursorLine", -- Can be a highlight or a hexadecimal color (#RRGGBB)
        mixing_color = "#000000", -- Can be None or a hexadecimal color (#RRGGBB). Used to blend the background color with the diagnostic background color with another color.
      },
      options = {
        -- Show the source of the diagnostic.
        show_source = false,

        -- Use your defined signs in the diagnostic config table.
        use_icons_from_diagnostic = false,

        -- Throttle the update of the diagnostic when moving cursor, in milliseconds.
        -- You can increase it if you have performance issues.
        -- Or set it to 0 to have better visuals.
        throttle = 20,

        -- The minimum length of the message, otherwise it will be on a new line.
        softwrap = 30,

        -- If multiple diagnostics are under the cursor, display all of them.
        multiple_diag_under_cursor = false,

        -- Enable diagnostic message on all lines.
        multilines = true,

        -- Show all diagnostics on the cursor line.
        show_all_diags_on_cursorline = true,

        -- Enable diagnostics on Insert mode. You should also se the `throttle` option to 0, as some artefacts may appear.
        enable_on_insert = false,

        overflow = {
          -- Manage the overflow of the message.
          --    - wrap: when the message is too long, it is then displayed on multiple lines.
          --    - none: the message will not be truncated.
          --    - oneline: message will be displayed entirely on one line.
          mode = "wrap",
        },

        -- Format the diagnostic message.
        -- Example:
        -- format = function(diagnostic)
        --     return diagnostic.message .. " [" .. diagnostic.source .. "]"
        -- end,
        format = nil,

        --- Enable it if you want to always have message with `after` characters length.
        break_line = {
          enabled = false,
          after = 30,
        },

        virt_texts = {
          priority = 2048,
        },

        -- Filter by severity.
        severity = {
          vim.diagnostic.severity.ERROR,
          vim.diagnostic.severity.WARN,
          vim.diagnostic.severity.INFO,
          vim.diagnostic.severity.HINT,
        },

        -- Overwrite events to attach to a buffer. You should not change it, but if the plugin
        -- does not works in your configuration, you may try to tweak it.
        overwrite_events = nil,
      },
    })
  end,
})

vim.pack.add({ "https://github.com/stevearc/oil.nvim" })
require("oil").setup({
  default_file_explorer = true,
  columns = { "icon" },
  view_options = {
    show_hidden = true,
  },
  sort = {
    { "type", "asc" },
    { "name", "asc" },
  },
})

-- Open parent directory in current window
vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Open parent directory in floating window
vim.keymap.set("n", "<leader>-", require("oil").toggle_float)

vim.pack.add({ "https://github.com/vimpostor/vim-tpipeline" })
