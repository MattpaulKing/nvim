local laravel = require("laravel")
laravel.setup({
	features = { pickers = { provider = "telescope" } },
	lsp_server = "laravel_lsp",
	v,
})
vim.g.Laravel = laravel

-- vim.keymap.set("n", "<leader>la", "<CMD>Laravel artisan<CR>", { desc = "Laravel Artisan Center" })
-- vim.keymap.set("n", "<leader>lr", "<CMD>Laravel routes<CR>", { desc = "Laravel Route Picker" })
-- vim.keymap.set("n", "<leader>lm", "<CMD>Laravel related<CR>", { desc = "Laravel Related Models/Views" })
vim.keymap.set("n", "<leader>la", function()
	Laravel.pickers.artisan()
end, { desc = "Laravel Artisan Picker" })
vim.keymap.set("n", "<leader>lr", function()
	Laravel.pickers.routes()
end, { desc = "Laravel Routes Picker" })
vim.keymap.set("n", "<leader>lm", function()
	Laravel.pickers.make()
end, { desc = "Laravel Make Picker" })
vim.keymap.set("n", "<leader>ll", function()
	Laravel.pickers.laravel()
end, { desc = "Laravel Core Picker" })
