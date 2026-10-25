vim.pack.add({ "https://github.com/RicardoRamirezR/blade-nav.nvim" })
require("blade-nav").setup({
	-- Master switch. Auto-disabled outside Laravel unless force_enable = true.
	enable = true,
	force_enable = false,

	cache_timeout = 50000, -- Cache TTL in ms
	debug = false,

	-- Completion behavior (applies to nvim-cmp, blink.cmp, and coq.nvim)
	close_tag_on_complete = true,
	include_routes_in_cmp = true,

	-- Inertia
	inertia_pages_path = nil, -- nil = "Pages" (default)
	inertia_extensions = { "vue", "tsx", "jsx", "ts", "js" },

	-- Vue
	jsconfig_path = "./jsconfig.json",

	-- Extra directories for <x-component> resolution
	laravel_components_paths = {},

	-- Navigation targets (gf)
	handlers = {
		directive = true,
		view = true,
		livewire = true,
		route = true,
		config = true,
		component = true,
		inertia = true,
		vue = true,
		lang = true,
	},

	-- Completion/integration sources
	integrations = {
		gf = true,
		cmp = true,
		blink = true,
	},

	-- Inline value annotations
	annotations = {
		show = false, -- Start with annotations visible
		hl = "Comment", -- Highlight group for virtual text
		prefix = " ⟶ ", -- Prefix before each value
		max_len = 160, -- Max display length before truncation
		debounce_ms = 120, -- Debounce for re-rendering on edits
		show_on_load = true, -- Render annotations when a buffer loads
		create_keymaps = false, -- Create K, <leader>bv, <leader>bcc maps
	},
})
