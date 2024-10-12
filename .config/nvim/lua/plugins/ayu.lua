return {
    "Shatur/neovim-ayu",
    priority = 1000,
    config = function()
        require("ayu").colorscheme()
    end,
}
