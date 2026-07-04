-- INFO: fuzzy finder
vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim", -- library dependency
})

vim.pack.add({
	"https://github.com/nvim-telescope/telescope.nvim", -- the fuzzy finder
})

require("telescope").setup({
	defaults = {
		wrap_results = true,
		layout_config = {
			horizontal = {
				width = 0.9,
				preview_cutoff = 0,
				preview_width = 0.5,
			},
		},
	},
})

local pickers = require("telescope.builtin")

vim.keymap.set("n", "<leader>pf", pickers.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>pg", pickers.live_grep, { desc = "[S]earch by [G]rep" })

-- telescope wrap lines
vim.api.nvim_create_autocmd("User", {
	pattern = "TelescopePreviewerLoaded",
	callback = function(args)
		if args.data.filetype ~= "help" then
			vim.wo.number = true
		else
			vim.wo.wrap = true
		end
	end,
})
--
