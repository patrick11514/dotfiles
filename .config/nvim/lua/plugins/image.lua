return {
	"3rd/image.nvim",
	build = false,
	config = function()
		require("image").setup({
			backend = "kitty",
			processor = "magick_cli",
			integrations = {
				markdown = {
					enabled = false,
				},
			},
		})
	end,
}
