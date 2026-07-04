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

vim.cmd([[colorscheme tokyonight]])

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
