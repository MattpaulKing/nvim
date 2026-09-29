---@type vim.lsp.Config

return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".git" },
	init_options = {
		settings = {
			lineLength = 100,
			lint = {
				select = { "E", "F", "I" },
				preview = true,
			},
			format = {
				preview = true,
			},
		},
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Only bind format-on-save if the attached client is Ruff
				if client and client.name == "ruff" then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = ev.buf,
						callback = function()
							-- Ruff supports both formatting and import organization via LSP
							-- This organizes imports AND formats the file synchronously
							vim.lsp.buf.format({ async = false, id = client.id })
						end,
					})
				end
			end,
		})
	end,
}
