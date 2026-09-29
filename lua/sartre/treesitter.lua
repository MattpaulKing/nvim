-- INFO: formatting and syntax highlighting
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" }, { confirm = false })
require("nvim-treesitter").setup({
	-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
	install_dir = vim.fn.stdpath("data") .. "/site",
})
-- equivalent to :TSUpdate
-- require("nvim-treesitter.install").update("all")
require("nvim-treesitter.config").setup({
	auto_install = true, -- autoinstall languages that are not installed yet
	install_dir = vim.fn.stdpath("data") .. "/site",
	ensure_installed = {
		"svelte",
		"html",
		"css",
		"javascript",
		"typescript",
		"python",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		local filetype = vim.bo.filetype

		if filetype and filetype ~= "" then
			pcall(vim.treesitter.start)
		end
	end,
})
