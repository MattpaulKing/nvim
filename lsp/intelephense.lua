return {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php", "blade" },
	root_markers = { "composer.json", ".git" },
	settings = {
		intelephense = {
			files = {
				maxSize = 5000000,
			},
		},
	},
}
