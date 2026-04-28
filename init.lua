-- colorscheme -----------------------------------------------------------------
local function refresh_colorscheme()
    vim.cmd.colorscheme("default")
    vim.api.nvim_set_hl(0, "Type",           {link = "DiagnosticWarn"})
    vim.api.nvim_set_hl(0, "PreProc",        {link = "Identifier"})
    vim.api.nvim_set_hl(0, "Constant",       {link = "Identifier"})
    vim.api.nvim_set_hl(0, "SpecialComment", {link = "Comment"})
end
vim.api.nvim_create_user_command('ColoRefresh', function(opts) refresh_colorscheme() end, {})
refresh_colorscheme()

-- basic behaviour -------------------------------------------------------------
vim.g.mapleader        = vim.keycode("<space>")
vim.g.maplocalleader   = vim.keycode("<space>")
vim.opt.laststatus     = 1
vim.opt.swapfile       = false
vim.opt.shada          = "" -- forgets marks, registers
vim.opt.mouse          = "" -- fully disable to avoid touchpad issues
vim.opt.signcolumn     = "no" -- yes:1 for diagnostics
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.guicursor      = "a:block,a:blinkwait0" -- cursor always block, no blink
vim.opt.wrap           = true
vim.opt.linebreak      = true
vim.opt.expandtab      = true
vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.colorcolumn    = "80"
vim.opt.scrolloff      = 99 -- cursor always mid-screen
vim.opt.virtualedit    = "block" -- visual mode past end of line
vim.g.netrw_liststyle  = 1
vim.o.timeoutlen       = 400
vim.o.completeopt      = "menu,nearest"
vim.opt.pumheight      = 3  -- how many suggestions to show
-- modify search path so it's recursive down
vim.opt.path:append("**")
vim.opt.wildignore:append({"*.o", "*.obj", "*.pyc"})

-- [[remap land]] (M = meta = alt key)  ----------------------------------------
-- quick save
vim.keymap.set("n", "<leader>w", "<cmd>update<CR>")
-- ESC working in terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")
-- [S]ubstitute in the visual area
-- -- with preview
vim.keymap.set("v", "<leader>s", ":s/") -- equiv: [[<Esc>:'<,'>s/]
-- -- NO preview
vim.keymap.set("v", "<leader><leader>s", "q:asubstitute//gcI<Esc>3hi")
-- -- and globally
vim.keymap.set("n", "<leader>s", "yiwq:a%substitute///gcI<Esc>5hpla")
-- [F]ind files from vim root
vim.keymap.set("n", "<leader>f", ":find ")
-- [N]ewline: paste line below + maintaing cursor column position
vim.keymap.set("n", "<C-n>", "<cmd>t.|<CR>")
-- open default file explorer (Netrw).
vim.keymap.set("n", "-", "<cmd>Explore<CR>")
-- resize splits
vim.keymap.set("n", "<C-Left>",  "<cmd>vertical   resize -2<CR>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical   resize +2<CR>")
vim.keymap.set("n", "<C-Down>",  "<cmd>horizontal resize -2<CR>")
vim.keymap.set("n", "<C-Up>",    "<cmd>horizontal resize +2<CR>")
-- [C]ompilation [M]ode / [C]ompile [M]e
-- set makeprg=... (escape spaces with \) ([] + q to go across errors)
vim.keymap.set("n", "<leader>m", "<cmd>make<CR>")
vim.keymap.set("n", "<leader>c", "<cmd>copen<CR>")
vim.keymap.set("n", "<leader><leader>c", "<cmd>cclose<CR>")
-- [V]im [G]rep (internal search) shortcut
vim.keymap.set("n", "<leader>vg", "q:ivimgrep//jg **/<Esc>6hi")
-- leader + p for pasting and not losing yanked buffer
vim.keymap.set("v", "<leader>p", '"_dP')
-- [*][S]urround with given thing
vim.keymap.set("v", "(s", 'c(<C-r>")<Esc>%')
vim.keymap.set("v", "[s", 'c[<C-r>"]<Esc>%')
vim.keymap.set("v", "{s", 'c{<C-r>"}<Esc>%')
vim.keymap.set("v", '"s', 'c"<C-r>""<Esc>%')
-- go [B]ack where you were [B]efore (the previous [B]uffer)
vim.keymap.set("n", "<leader>b", "<cmd>b#<CR>")
-- homemade autopairs
---- open and automatically close
vim.keymap.set("i", "((",  "()<Left>")
vim.keymap.set("i", "[[",  "[]<Left>")
vim.keymap.set("i", "{{",  "{}<Left>")
vim.keymap.set('i', '""',  '""<Left>')
vim.keymap.set('i', "''",  "''<Left>")
---- open and automatically close, on multiple lines
vim.keymap.set("i", "(<CR>", "()<Left><CR><Esc>O")
vim.keymap.set("i", "[<CR>", "[]<Left><CR><Esc>O")
vim.keymap.set("i", "{<CR>", "{}<Left><CR><Esc>O")
-- nvim terminal
vim.keymap.set("n", "<leader>t", "<cmd>terminal<CR>A")
-- [N]orm
vim.keymap.set("v", "<leader>n", ":norm ")

-- [[ [TR]im [TR]ailing whitespace ]] ------------------------------------------
vim.api.nvim_create_user_command('TRimTrailingWhiteSpace',
    function() vim.cmd([[%substitute/\s\+$//e]]) end, {}
)

-- [[ Highlight on yank ]] -----------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.hl.on_yank() end,
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    pattern = "*",
})

-- [A]lign ---------------------------------------------------------------------
local function align_line(line, sep, maxpos)
    local before, after = line:match('(.-)%s*(' .. sep .. '.*)')
    if not before then return line end
    local spaces = string.rep(' ', maxpos - #before)
    return before .. spaces .. after
end
local function align_section(first_line, last_line, sep)
    local section = vim.api.nvim_buf_get_lines(0, first_line - 1, last_line, false)
    local maxpos = 0
    for _, line in ipairs(section) do
        local pos = line:find(' *' .. sep)
        if pos and pos > maxpos then maxpos = pos end
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
vim.keymap.set('v', '<leader>a', ':Align<CR>', { silent = true })

local FILE_TYPE = "FileType"

-- quickfix list height --------------------------------------------------------
vim.api.nvim_create_autocmd(FILE_TYPE,
    { pattern = "qf", callback = function() vim.cmd("resize 4") end }
)

-- snippets --------------------------------------------------------------------
local function _expand_snippet(trigger, body)
    -- https://boltless.me/posts/neovim-config-without-plugins-2025/
    local c = vim.fn.nr2char(vim.fn.getchar(0))
    -- Only accept "<C-]>" as a trigger key.
    if c == "" then vim.snippet.expand(body)
    else vim.api.nvim_feedkeys(trigger .. c, "i", true)
    end
end
local function _snippet(trigger, body)
    vim.keymap.set("ia", trigger, function() _expand_snippet(trigger, body) end, {})
end
-- organize snippets by file type
local SNIPPET_GROUP = "SnippetGroup"
vim.api.nvim_create_augroup(SNIPPET_GROUP, { clear = true })
vim.api.nvim_create_autocmd(FILE_TYPE, { group = SNIPPET_GROUP, pattern = {"python"},
    callback = function()
        _snippet("main", [[
def main():
    ${1:print("Hello world")}


if __name__ == "__main__":
    main()
]])
        _snippet("def", 'def ${1:func}($2) -> ${3:None}:\n\t$4')
        _snippet("dbg", 'print(f"{$1 = }")')
        _snippet("ifn", 'if ($1 := $2) ${3:is None}:\n\t${4:return}')
        _snippet("lgr", '${4:lgr}.${3:info}("$1" % ($2))')
    end
})
vim.api.nvim_create_autocmd(FILE_TYPE, { group = SNIPPET_GROUP, pattern = {"c", "h", "cpp"},
    callback = function()
        _snippet("malloc", [[
${1:type} *${2:name} = malloc(sizeof(*$2)*${3:1});
if ($2 == NULL) ${4:assert(false && "malloc failed")};
$5
free($2);
]]
)
        _snippet("for",   "for (size_t ${1:i} = ${2:0}; $1 < ${3:n}; ++$1) {\n\t$4\n}")
        _snippet("ifn",   '#ifndef ${1:NAME}\n#define $1 $2\n$3\n#endif // $1')
        _snippet("void",  '${1:void} $2(${3:void}) {\n\t$4\n}')
        _snippet("ty",    'typedef $1 {\n\t$3\n} $2;')
        _snippet("dbg",   'printf("$1 = %$2\\n", $1);')
        _snippet("print", 'printf("%$1\\n", $2);')

    end
})
vim.api.nvim_create_autocmd(FILE_TYPE, { group = SNIPPET_GROUP, pattern = {"html"},
    callback = function() _snippet("t", '<$1>\n\t$2\n</$1>') end
})
vim.api.nvim_create_autocmd(FILE_TYPE, { group = SNIPPET_GROUP, pattern = {"tex"},
    callback = function() _snippet("b", '\\begin{$1}\n$2\n\\end{$1}') end
})
vim.api.nvim_create_autocmd(FILE_TYPE, { group = SNIPPET_GROUP, pattern = {"rust"},
    callback = function()
        _snippet("match", [[
match $1 {
    Ok($2) => {$3},
    Err(${4:err}) => {$5},
    Some($2) => {$3},
    None => {$5},
}
]])
        _snippet("fn",    'fn ${1:name}($2) -> $3 {\n\t$4\n}')
        _snippet("let",   'let $1 = $2;')
        _snippet("print", 'println!("{}", $1);')
    end
})
vim.api.nvim_create_autocmd(FILE_TYPE, { group = SNIPPET_GROUP, pattern = {"go"},
    callback = function()
        _snippet("call", [[
${1:_}, ${2:err} := ${3:name}($4)
if $2 != nil {
    ${5:return nil}, $2
}
]])
        _snippet("func",  'func ${1:name}($2) $3 {\n\t$4\n}')
        _snippet("type",  'type $1 ${2:struct} {\n\t$3\n}')
        _snippet("meth",  'func ($1) ${2:name}($3) $4 {\n\t$5\n}')
        _snippet("ife",   'if ${1:err} != nil {\n\t${2:return nil, err}\n}')
        _snippet("range", 'for ${1:_}, $2 := range $3 {\n\t$4\n}')
        _snippet("for",   'for ${1:i} := 0; $1 < ${2:n}; $1++ {\n\t$3\n}')
        _snippet("app",   '$1 = append($1, $2)')
    end
})

-- filetype-specific keymaps -- automagically add stuff here -------------------
local function filetype_keymap(pattern, mode, key, val)
    vim.api.nvim_create_autocmd("BufEnter", { group = SNIPPET_GROUP, pattern = {pattern},
        callback = function(ev) vim.keymap.set(mode, key, val) end
    })
    vim.api.nvim_create_autocmd("BufLeave", { group = SNIPPET_GROUP, pattern = {pattern},
        callback = function(ev) vim.keymap.del(mode, key) end
    })
end
filetype_keymap("*.go", "i", ":", " := ")
filetype_keymap("*.rs", "i", "<<", "<><Esc>i")
filetype_keymap("*.rs", "i", "/*", "/*  */<Esc>2hi")
filetype_keymap("*.c",  "i", "/*", "/*  */<Esc>2hi")
filetype_keymap("*.h",  "i", "/*", "/*  */<Esc>2hi")

-- here be plugins -------------------------------------------------------------
vim.opt.winborder = "single"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup {
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
                    -- {name = "nvim_lsp", }, -- disable for a quiet lsp experience, C-X C-O
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
                    -- "grt" is mapped in Normal            mode to |vim.lsp.buf.type_definition()|
                    -- "grx" is mapped in Normal            mode to |vim.lsp.codelens.run()|
                    vim.keymap.set("n", "ggd",       vim.lsp.buf.definition,    {buffer = event.buf})
                    vim.keymap.set("n", "K",         vim.lsp.buf.hover,         {buffer = event.buf})
                    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {buffer = event.buf})
                end,
            })
            local servers = {
                pyright = {},
                -- rust_analyzer = {},
                -- gopls = {},
                -- clangd = {},
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
