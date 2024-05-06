local lualine = require("lualine")

-- configure lualine with modified theme
lualine.setup({
    options = {
        icons_enabled = false,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {},
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = {},
        lualine_z = { 'location', "os.date('%a %b %d %H:%M')" }
    },
    tabline = {
        lualine_a = { 'buffers' }
    }
})
