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
