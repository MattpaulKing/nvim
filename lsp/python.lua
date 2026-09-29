---@brief
---
--- https://github.com/sveltejs/language-tools/tree/master/packages/language-server
---
--- Note: assuming that [ts_ls](#ts_ls) is setup, full JavaScript/TypeScript support (find references, rename, etc of symbols in Svelte files when working in JS/TS files) requires per-project installation and configuration of [typescript-svelte-plugin](https://github.com/sveltejs/language-tools/tree/master/packages/typescript-plugin#usage).
---
--- `svelte-language-server` can be installed via `npm`:
--- ```sh
--- npm install -g svelte-language-server
--- ```

---@type vim.lsp.Config

return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	settings = {
		basedpyright = {
			disableOrganizeImports = true, -- Let Ruff handle imports
			analysis = {
				autoSearchPaths = true,
				typeCheckingMode = "recommended", -- Alternatives: "off", "basic", "strict"
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
			},
		},
	},
	root_markers = {
		"pyrightconfig.json",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		".git",
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.py",
			callback = function(args)
				vim.lsp.buf.format({
					bufnr = args.buf,
					-- This ensures only Ruff acts as the formatter instead of competing with Basedpyright
					filter = function(client)
						return client.name == "ruff"
					end,
					timeout_ms = 500,
				})
			end,
		})
	end,
}
