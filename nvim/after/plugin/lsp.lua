vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

vim.diagnostic.config({
    virtual_text = true
})

require('lspkind').init({
    -- defines how annotations are shown
    -- default: symbol
    -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
    mode = 'symbol_text',

    -- default symbol map
    -- can be either 'default' (requires nerd-fonts font) or
    -- 'codicons' for codicon preset (requires vscode-codicons font)
    --
    -- default: 'default'
    preset = 'default',

    -- override preset symbols
    --
    -- default: {}
    -- symbol_map
})

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        -- these will be buffer-local keybindings
        -- because they only work if you have an active language server

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

local merge_table = function(table1, table2)
    for _, value in ipairs(table2) do
        if value ~= nil then
            table1[#table1 + 1] = value
        end
    end
    return table1
end

local split_by_new_line = function(glob)
    local pathes = vim.fn.glob(vim.fn.getcwd() .. '/' .. glob)
    if pathes == nil then
        return {}
    end
    return vim.split(pathes, '\n', { trimempty = true })
end

local default_setup = function(server)
    local lsp_config = require('lspconfig')
    if server == 'omnisharp' then
        local util = require('lspconfig/util')

        local solutions = split_by_new_line("*.sln")
        local paths = merge_table(solutions, {})

        local result = {}
        for i, line in pairs(paths) do
            result[i] = line
        end

        local has_only_one_sln = #result == 1
        local has_has_more_than_one_sln = #result > 1

        local solution_path = nil
        if has_has_more_than_one_sln then
            vim.ui.select(result, {
                prompt = 'What solution you would like to work on?',
                format_item = function(item)
                    return item:match("^.+/(.+)$")
                end
            }, function(input) solution_path = input end)
        elseif has_only_one_sln then
            solution_path = result[1]
        end

        if solution_path ~= nil then
            lsp_config[server].setup({
                capabilities = lsp_capabilities,
                cmd = { vim.fn.stdpath "data" .. "/mason/packages/omnisharp/omnisharp", '-s', solution_path },
            })
        else
            lsp_config[server].setup({
                capabilities = lsp_capabilities,
                cmd = { vim.fn.stdpath "data" .. "/mason/packages/omnisharp/omnisharp" },
                root_dir = util.root_pattern('*.sln', '*.csproj')
            })
        end
    else
        lsp_config[server].setup({
            capabilities = lsp_capabilities,
        })
    end
end

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'omnisharp', 'rust_analyzer', 'lua_ls', 'dockerls', 'docker_compose_language_service', 'fsautocomplete', 'html', 'jsonls', 'tsserver', 'marksman', 'sqlls', 'taplo', 'vimls', 'lemminx', 'yamlls' },
    handlers = {
        default_setup,
    },
})

local cmp = require('cmp')
local lspkind = require("lspkind")
cmp.setup({
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "luasnip" },
        { name = "nvim_lua" },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 30 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"
            return kind
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})
