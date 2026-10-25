vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})
require("sartre")
