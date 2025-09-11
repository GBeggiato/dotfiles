vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.mouse = ""
vim.opt.signcolumn = "yes:1" -- "no"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.guicursor = "a:block,a:blinkwait0" -- cursor always block, no blink
vim.opt.wrap = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.colorcolumn = "80"
vim.opt.clipboard = "unnamedplus" -- sync vim and standard copy register
vim.opt.scrolloff = 999 -- cursor always mid-screen
vim.opt.virtualedit = "block" -- visual mode past end of line
-- [[ Highlight on yank ]]
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank() end,
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    pattern = "*",
})
-- readable errors (LSP): see <leader>d below
vim.diagnostic.config({virtual_text = false, virtual_lines = false})
vim.opt.winborder = "single"
-- default file explorer (Netrw).
---- no banner
vim.g.netrw_banner = 0
---- tree view
vim.g.netrw_liststyle = 3 -- 0: base, 1: date, 3: tree
-- how many suggestions in floating windows
vim.opt.pumheight = 3

-- [[remap land]] (M = meta = alt key)
-- better cmd line
vim.keymap.set({"n", "v"}, ":", "q:a")
-- quick save
vim.keymap.set("n", "<leader>w", "<cmd>update<CR>")
-- Ctrl k as ESC
vim.keymap.set({"n", "i", "v", "s", "x", "c", "o", "l"}, "<C-k>", "<Esc>")
vim.keymap.set("t", "<C-k>", "<C-\\><C-N>")
-- ESC working in terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")
-- [S]ubstitute
vim.keymap.set("v", "<leader>s", ":<C-f>asubstitute//gcI<Esc>3hi")
vim.keymap.set("n", "<leader>s", "yiw:<C-f>a%substitute///gcI<Esc>5hpla")
-- modify search path so it's recursive down
vim.opt.path = vim.opt.path + "**"
-- [F]ind files from vim root
vim.keymap.set("n", "<leader>f", ":find ")
-- [N]ewline: paste line below + maintaing cursor column position
vim.keymap.set("n", "<C-n>", "<cmd>t.|<CR>")
-- open default file explorer (Netrw).
vim.keymap.set("n", "-", "<cmd>Explore<CR>")
-- resize splits
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -3<CR>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +3<CR>")
vim.keymap.set("n", "<C-Down>", "<cmd>horizontal resize -3<CR>")
vim.keymap.set("n", "<C-Up>", "<cmd>horizontal resize +3<CR>")
-- [C]ompilation [M]ode / [C]ompile [M]e
-- set makeprg=... (escape spaces with \) ([] + q to go across errors)
vim.keymap.set("n", "<leader>cm", "<cmd>make<CR>")
vim.keymap.set("n", "<leader>co", "<cmd>copen<CR>")
vim.keymap.set("n", "<leader>cc", "<cmd>cclose<CR>")
-- [V]im [G]rep (internal search) shortcut
vim.keymap.set("n", "<leader>vg", ":<C-f>ivimgrep//jg **/<Esc>6hi")
-- leader + p for pasting and not losing yanked buffer
vim.keymap.set("v", "<leader>p", "\"_dP")
-- [*][S]urround with given thing
vim.keymap.set("v", "(s", "c(<C-r>\")<C-\\><C-N>%")
vim.keymap.set("v", "[s", "c[<C-r>\"]<C-\\><C-N>%")
vim.keymap.set("v", "{s", "c{<C-r>\"}<C-\\><C-N>%")
vim.keymap.set("v", '"s', 'c"<C-r>\""<C-\\><C-N>%')
vim.keymap.set("v", "'s", "c'<C-r>\"'<C-\\><C-N>%")
-- go [B]ack where you were [B]efore (the previous [B]uffer)
vim.keymap.set("n", "<leader>b", "<cmd>b#<CR>")
-- homemade autopairs
---- manually open and close
vim.keymap.set("i", "()", "()")
vim.keymap.set("i", "[]", "[]")
vim.keymap.set("i", "{}", "{}")
---- open and go to newline with indent
vim.keymap.set("i", "(<CR>", "()<Esc>i<CR><Esc>O")
vim.keymap.set("i", "[<CR>", "[]<Esc>i<CR><Esc>O")
vim.keymap.set("i", "{<CR>", "{}<Esc>i<CR><Esc>O")
---- open and automatically close
vim.keymap.set("i", "(", "()<Esc>i")
vim.keymap.set("i", "[", "[]<Esc>i")
vim.keymap.set("i", "{", "{}<Esc>i")
vim.keymap.set("i", '"', '""<Esc>i')
-- the most basic snippets ever
---- go error handling
vim.keymap.set("n", "<leader>e", "A<CR>if err != nil {<CR>return nil, err<CR>}<Esc>")
---- c for loop
vim.keymap.set("n", "<leader>l", "A<CR>for (size_t i = 0; i < n; ++i){<CR>}<CR><Esc>kk0fn")
-- nvim terminal
vim.keymap.set("n", "<leader>t", "<cmd>terminal<CR>A")

-- colorscheme: Pond --
vim.opt.termguicolors = true
vim.cmd [[ colorscheme default ]]
vim.cmd [[ hi normal guibg=Black ]]
vim.cmd [[ hi Pmenu guibg=Indigo ]] -- native floating windows
vim.cmd [[ hi PmenuThumb guibg=Indigo ]]
vim.cmd [[ hi Search guibg=Indigo ]]-- search background
vim.cmd [[ hi StatusLine guibg=Indigo guifg=NvimLightGrey2]] -- active window statusline
vim.cmd [[ hi PmenuSel guifg=DarkMagenta guibg=NvimLightGrey2 ]] -- selection background
vim.cmd [[ hi CurSearch guibg=DarkMagenta guifg=NvimLightGrey2 ]] -- search background
vim.cmd [[ hi StatusLineNC guibg=DarkMagenta guifg=NvimLightGrey2]] -- other statuslines
vim.cmd [[ hi Comment guifg=#00FF9F ]] -- acqua/green, NvimLightGreen
vim.cmd [[ hi LineNr guifg=NvimLightGrey2 ]]
vim.cmd [[ hi Statement guifg=Yellow gui=NONE ]] -- PreProc
vim.cmd [[ hi String guifg=Lime ]]
vim.cmd [[ hi Function guifg=NvimLightBlue ]]
vim.cmd [[ hi Type guifg=DarkOrange ]]

-- here be plugins
-- set up lazy vim for plugins (~/.local/share/nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup {
    { -- Autocompletion engine
        "hrsh7th/nvim-cmp", event = "InsertEnter",
        dependencies = { "hrsh7th/cmp-nvim-lsp", },
        config = function()
            local cmp = require("cmp")
            cmp.setup {
                completion = { completeopt = "menu,noinsert" },
                mapping = cmp.mapping.preset.insert {
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-y>"] = cmp.mapping.confirm { select = true },
                    ["<CR>"] = cmp.mapping.confirm { select = true },
                },
                sources = {
                    {name = "nvim_lsp"},
                    {name = "buffer"},
                    {name = "path"},
                    {name = "snippets"},
                },
            }
        end,
    },
    { -- LSP
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup(
                    "kickstart-lsp-attach",
                    { clear = true }
                ),
                callback = function(event)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = event.buf})
                    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {buffer = event.buf})
                    vim.keymap.set("n","gd", vim.lsp.buf.definition, {buffer = event.buf})
                    vim.keymap.set("n","<leader>d", vim.diagnostic.open_float, {buffer = event.buf})
                    vim.keymap.set("n","gr", vim.lsp.buf.references, {buffer = event.buf})
                end,
            })
            local servers = {
                pyright = {},
                rust_analyzer = {},
                clangd = {},
                gopls = {},
            }
            require("mason").setup()
            local ensure_installed = vim.tbl_keys(servers or {})
            require("mason-tool-installer").setup {ensure_installed = ensure_installed,}
            local caps = vim.lsp.protocol.make_client_capabilities()
            caps = vim.tbl_deep_extend("force", caps, require("cmp_nvim_lsp").default_capabilities())
            require("mason-lspconfig").setup { handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend("force", {}, caps, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            }, }
        end,
    },
}

-- more stuff
-- [A]lign
local function align_section(first_line, last_line, sep)
    local section = vim.api.nvim_buf_get_lines(0, first_line - 1, last_line, false)
    local maxpos = 0
    for _, line in ipairs(section) do
        local pos = line:find(' *' .. sep)
        if pos and pos > maxpos then maxpos = pos end
    end
    local function align_line(line)
        local before, after = line:match('(.-)%s*(' .. sep .. '.*)')
        if not before then return line end
        local spaces = string.rep(' ', maxpos - #before)
        return before .. spaces .. after
    end
    for i, line in ipairs(section) do section[i] = align_line(line, sep, maxpos) end
    vim.api.nvim_buf_set_lines(0, first_line - 1, last_line, false, section)
end
vim.api.nvim_create_user_command(
    'Align',
    function(opts)
        local first_line = opts.line1
        local last_line = opts.line2
        local separator = vim.fn.input('Enter alignment separator: ', '')
        if separator ~= '' then align_section(first_line, last_line, separator) end
    end, 
    { nargs = '?', range = true }
)
-- [A]lign on = (or other) sign
vim.keymap.set('v', '<leader>a', ':Align<CR>', { silent = true })

