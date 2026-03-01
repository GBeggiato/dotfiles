vim.cmd('colorscheme habamax')
-- basic behaviour -------------------------------------------------------------
vim.g.mapleader        = vim.keycode("<space>")
vim.g.maplocalleader   = vim.keycode("<space>")
vim.opt.swapfile       = false
vim.opt.shada          = "" -- forgets marks, registers
vim.opt.mouse          = "" -- fully disable to avoid touchpad issues
vim.opt.signcolumn     = "no" -- yes:1 for diagnostics
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.guicursor      = "a:block,a:blinkwait0" -- cursor always block, no blink
vim.opt.wrap           = true
vim.opt.expandtab      = true
vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
-- vim.opt.ignorecase     = true
-- vim.opt.smartcase      = true
vim.opt.colorcolumn    = "80"
vim.opt.clipboard      = "unnamedplus" -- sync vim and standard copy register
vim.opt.scrolloff      = 99 -- cursor always mid-screen
vim.opt.virtualedit    = "block" -- visual mode past end of line
vim.g.netrw_liststyle  = 1
vim.o.timeoutlen       = 400
vim.o.completeopt      = "menu,popup,nearest"
vim.opt.pumheight      = 3  -- how many suggestions to show
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc" })
-- vim.opt.undofile      = true                      -- Enable persistent undo
-- vim.opt.undodir       = vim.fn.expand("~/.undodir") -- Set custom undo directory
-- [[remap land]] (M = meta = alt key)  ----------------------------------------
-- quick save
vim.keymap.set("n", "<leader>w", "<cmd>update<CR>")
-- Ctrl k as ESC
vim.keymap.set({"n", "i", "v", "s", "x", "c", "o", "l"}, "<C-k>", "<Esc>")
vim.keymap.set("t", "<C-k>", "<C-\\><C-N>")
-- ESC working in terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")
-- [S]ubstitute in the visual area
vim.keymap.set("v", "<leader>s", "q:asubstitute//gcI<Esc>3hi")
-- and globally
vim.keymap.set("n", "<leader>s", "yiwq:a%substitute///gcI<Esc>5hpla")
-- modify search path so it's recursive down
vim.opt.path:append("**")
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
vim.keymap.set("i", "((",  "()<Esc>i")
vim.keymap.set("i", "[[",  "[]<Esc>i")
vim.keymap.set("i", "{{",  "{}<Esc>i")
vim.keymap.set('i', '""',  '""<Esc>i')
---- open and automatically close, on multiple lines
vim.keymap.set("i", "(<CR>", "()<Esc>i<CR><Esc>O")
vim.keymap.set("i", "[<CR>", "[]<Esc>i<CR><Esc>O")
vim.keymap.set("i", "{<CR>", "{}<Esc>i<CR><Esc>O")
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

-- snippets --------------------------------------------------------------------
local function _expand_snippet(trigger, body)
    -- https://boltless.me/posts/neovim-config-without-plugins-2025/
    local c = vim.fn.nr2char(vim.fn.getchar(0))
    -- Only accept "<C-]>" (or "]") as a trigger key.
    if (c == "" or c == "]") then vim.snippet.expand(body) -- move between "nodes" with <tab>
    else vim.api.nvim_feedkeys(trigger .. c, "i", true)
    end
end
local function _snippet(trigger, body)
    vim.keymap.set("ia", trigger, function() _expand_snippet(trigger, body) end, {})
end
-- organize snippets by file type
local snippet_group = "SnippetGroup"
local file_type = "FileType"
vim.api.nvim_create_augroup(snippet_group, { clear = true })

vim.api.nvim_create_autocmd(file_type, { group = snippet_group, pattern = {"python"},
    callback = function()
        _snippet("main", 'def main():\n\t${1:print("Hello world")}\n\n\nif __name__ == "__main__":\n\tmain()')
        _snippet("def",  'def ${1:func}($2) -> ${3:None}:\n\t$4')
        _snippet("dbg",  'print(f"{$1 = }")')
    end
})
vim.api.nvim_create_autocmd(file_type, { group = snippet_group, pattern = {"c", "h", "cpp"},
    callback = function()
        _snippet("for",    "for (size_t ${1:i} = 0; $1 < ${2:n}; ++$1){\n\t$3\n}")
        _snippet("ifn",    '#ifndef ${1:NAME}\n#define $1 $2\n$3\n#endif // $1')
        _snippet("malloc", [[
${1:type} *${2:name} = malloc(sizeof(*$2)*${3:1});
if ($2 == NULL) {
    ${4:assert(false) && "malloc failed"};
}
free($2);
]]
)
    end
})
vim.api.nvim_create_autocmd(file_type, { group = snippet_group, pattern = {"html"},
    callback = function() _snippet("t", '<$1>\n\t$2\n</$1>') end
})
vim.api.nvim_create_autocmd(file_type, { group = snippet_group, pattern = {"rust"},
    callback = function()
        _snippet("fn",    'fn ${1:name}($2) -> $3 {\n\t$4\n}')
        _snippet("match", [[
match $1 {
    Ok($2) => {$3},
    Err(${4:err}) => {$5},
    Some($2) => {$3},
    None => {$5},
}
]])
    end
})
vim.api.nvim_create_autocmd(file_type, { group = snippet_group, pattern = {"go"},
    callback = function()
        _snippet("func",  'func ${1:name}($2) $3 {\n\t$4\n}')
        _snippet("meth",  'func ($1) ${2:name}($3) $4 {\n\t$5\n}')
        _snippet("call",  '${1:x}, ${2:err} := ${3:name}($4)\nif $2 != nil {\n\t${5:return nil, err}\n}')
        _snippet("ife",   'if ${1:err} != nil {\n\t${2:return nil, err}\n}')
        _snippet("range", 'for ${1:_}, $2 := range $3 {\n\t$4\n}')
        _snippet("for",   'for ${1:i} := 0; $1 < ${2:n}; $1++ {\n\t$3\n}')
        _snippet("app",   '$1 = append($1, $2)')
    end
})

-- filetype-specific keymaps -- automagically add stuff here -------------------
local function filetype_keymap(pattern, mode, key, val)
    vim.api.nvim_create_autocmd("BufEnter", { group = snippet_group, pattern = {pattern},
        callback = function(ev) vim.keymap.set(mode, key, val) end
    })
    vim.api.nvim_create_autocmd("BufLeave", { group = snippet_group, pattern = {pattern},
        callback = function(ev) vim.keymap.del(mode, key) end
    })
end

filetype_keymap("*.go", "i", " :", " := ")
filetype_keymap("*.rs", "i", "<<", "<><Esc>i")
