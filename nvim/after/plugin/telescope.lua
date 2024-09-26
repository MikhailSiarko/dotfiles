local builtin = require('telescope.builtin')
vim.keymap.set('n', '<A-p>', builtin.find_files, {})
vim.keymap.set('n', '<A-G>', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<A-g>', builtin.live_grep, {})
vim.keymap.set('n', '<A-b>', builtin.buffers, {})
vim.keymap.set('n', '<A-t>', builtin.help_tags, {})

require("telescope").setup({
    defaults = {
        file_ignore_patterns = {
            ".git/",
            "node_modules/",
            "vendor/",
            "dist/",
            "build/",
            "target/",
            "out/",
            "obj/",
            "bin/",
            "cache/",
            "logs/",
            "tmp/",
            "temp/",
            "backup/",
            "%.lock"
        }
    }
})
