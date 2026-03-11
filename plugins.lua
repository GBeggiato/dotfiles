-- here be plugins -------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
local function disable_ts(bufnr) return vim.api.nvim_buf_line_count(bufnr) > 8000 end
local PLUGIN_FILES = { "c", "h", "cpp", "python", "rust", "go", "lua" }
require("lazy").setup {
    -- {
    --     "nvim-treesitter/nvim-treesitter",
    --     dependencies = {"https://github.com/nvim-treesitter/nvim-treesitter-textobjects", },
    --     ft = PLUGIN_FILES, build = ":TSUpdate", ensure_installed = PLUGIN_FILES,
    --     config = function()
    --         require("nvim-treesitter.configs").setup {
    --             auto_install = false,
    --             highlight = { enable = true,
    --                 disable = function(lang, bufnr) return disable_ts(bufnr) end,
    --             },
    --             indent = { enable = true,
    --                 disable = function(lang, bufnr) return disable_ts(bufnr) end,
    --             },
    --             textobjects = {
    --                 select = { enable = true,
    --                     disable = function(lang, bufnr) return disable_ts(bufnr) end,
    --                     lookahead = true,
    --                     keymaps = {
    --                         ["if"] = "@function.inner",    ["af"] = "@function.outer",
    --                         ["ic"] = "@class.inner",       ["ac"] = "@class.outer",
    --                         ["il"] = "@loop.inner",        ["al"] = "@loop.outer",
    --                         ["ii"] = "@conditional.inner", ["ai"] = "@conditional.outer",
    --                     }
    --                 },
    --                 swap = { enable = true,
    --                     disable = function(lang, bufnr) return disable_ts(bufnr) end,
    --                     swap_next     = { ["<C-j>"] = "@parameter.inner", },
    --                     swap_previous = { ["<C-h>"] = "@parameter.inner", },
    --                 },
    --             },
    --         }
    --     end,
    -- },
    { -- Autocompletion engine
        "hrsh7th/nvim-cmp", event = "InsertEnter",
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                completion = { completeopt = "menu,noinsert", },
                mapping = cmp.mapping.preset.insert {
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-y>"] = cmp.mapping.confirm {select = true},
                    ["<CR>"]  = cmp.mapping.confirm {select = true},
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                },
                sources = {
                    {name = "buffer", },
                    {name = "path", },
                    {name = "nvim_lsp", }, -- disable for a quiet lsp experience
                },
                -- keep the suggestion menu short and nice so the docs are not squashed
                window = {
                    documentation = {
                        max_height = 12,
                        max_width = 50,
                        border = "single",
                    }
                },
                formatting = {
                    fields = {"abbr", "kind"}, -- menu (source path)
                    format = function(_, vim_item)
                        vim_item.abbr = string.sub(vim_item.abbr, 1, 14)
                        vim_item.kind = string.sub(vim_item.kind, 1, 4)
                        return vim_item
                    end
                },
            })
        end,
    },
    { -- LSP
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    -- These GLOBAL keymaps are created unconditionally when Nvim starts:
                    -- "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
                    -- "grn" is mapped in Normal            mode to |vim.lsp.buf.rename()|
                    -- "grr" is mapped in Normal            mode to |vim.lsp.buf.references()|
                    -- "gri" is mapped in Normal            mode to |vim.lsp.buf.implementation()|
                    -- "gO" is mapped in Normal             mode to |vim.lsp.buf.document_symbol()|
                    -- CTRL-S is mapped in Insert           mode to |vim.lsp.buf.signature_help()|
                    vim.keymap.set("n", "gd",        vim.lsp.buf.definition,    {buffer = event.buf})
                    vim.keymap.set("n", "K",         vim.lsp.buf.hover,         {buffer = event.buf})
                    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {buffer = event.buf})
                end,
            })
            local servers = {
                pyright = {},
                rust_analyzer = {},
                gopls = {},
                clangd = {},
            }
            require("mason").setup()
            local ensure_installed = vim.tbl_keys(servers or {})
            require("mason-tool-installer").setup {ensure_installed = ensure_installed,}
            local caps = vim.lsp.protocol.make_client_capabilities()
            caps = vim.tbl_deep_extend("force", caps, require("cmp_nvim_lsp").default_capabilities())
            require("mason-lspconfig").setup{ handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend("force", {}, caps, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            }, }
        end,
    },
}
