local gh = function(repo)
	return "https://github.com/" .. repo
end

return {
	{ src = gh("MunifTanjim/nui.nvim") },
	{ src = gh("nvim-lua/plenary.nvim") },
	{ src = gh("nvim-neotest/nvim-nio") },
	{ src = gh("adalessa/laravel.nvim") },
}
