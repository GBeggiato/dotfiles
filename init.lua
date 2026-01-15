-------------------------------- basic behaviour -------------------------------
vim.g.mapleader        = vim.keycode("<space>")
vim.g.maplocalleader   = vim.keycode("<space>")
vim.opt.swapfile       = false
vim.opt.shada          = "" -- forgets marks, registers
vim.opt.mouse          = "" -- fully disable to avoid touchpad issues
vim.opt.signcolumn     = "yes:1"
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.guicursor      = "a:block,a:blinkwait0" -- cursor always block, no blink
vim.opt.wrap           = true
-- Set no wrap for quickfix windows
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("QuickfixSettings", { clear = true }),
    pattern = "qf", callback = function() vim.opt_local.wrap = false end
})
vim.opt.expandtab      = true
vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
-- vim.opt.ignorecase     = true
-- vim.opt.smartcase      = true
vim.opt.colorcolumn    = "80"
vim.opt.clipboard      = "unnamedplus" -- sync vim and standard copy register
vim.opt.scrolloff      = 99 -- cursor always mid-screen
vim.opt.virtualedit    = "block" -- visual mode past end of line
vim.g.netrw_liststyle  = 1 -- default file explorer (Netrw). 0: base, 1: date, 3: tree
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc" })
vim.o.timeoutlen       = 400
-- popup menu style
vim.o.completeopt      = "menu,popup,nearest" -- (nearest: ctrl-p for words above, -n for words below)
vim.opt.pumheight      = 3  -- 3 suggestions
vim.opt.pumwidth       = 10 -- Minimum width
vim.opt.pummaxwidth    = 20 -- Maximum width (check MSW vim.cmd('set pumwidth=30') vim.cmd('set pummaxwidth=50'))
--------------------- [[remap land]] (M = meta = alt key) ----------------------
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
---- manually open and close
vim.keymap.set("i", "()", "()")
vim.keymap.set("i", "[]", "[]")
vim.keymap.set("i", "{}", "{}")
---- open and automatically close, on multiple lines
vim.keymap.set("i", "(<CR>", "()<Esc>i<CR><Esc>O")
vim.keymap.set("i", "[<CR>", "[]<Esc>i<CR><Esc>O")
vim.keymap.set("i", "{<CR>", "{}<Esc>i<CR><Esc>O")
vim.keymap.set("i", '"<CR>', '""<Esc>i<CR><Esc>O')
---- open and automatically close
vim.keymap.set("i", "(", "()<Esc>i")
vim.keymap.set("i", "[", "[]<Esc>i")
vim.keymap.set("i", "{", "{}<Esc>i")
vim.keymap.set("i", '"', '""<Esc>i')
-- nvim terminal
vim.keymap.set("n", "<leader>t", "<cmd>terminal<CR>A")
-- [N]orm
vim.keymap.set("v", "<leader>n", ":norm ")
---------------- [[ [RM] remove trailing whitespace ]] -------------------------
vim.api.nvim_create_user_command('TRimTrailingWhiteSpace', function() vim.cmd([[%substitute/\s\+$//e]]) end, {})
----------------------- [[ Highlight on yank ]] --------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.hl.on_yank() end,
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    pattern = "*",
})
------------------------------- [A]lign ----------------------------------------
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
        local separator = vim.fn.input('Enter alignment separator: ', '=')
        if separator ~= '' then align_section(first_line, last_line, separator) end
    end,
    { nargs = '?', range = true }
)
vim.keymap.set('v', '<leader>a', ':Align<CR>', { silent = true })
------------------------------- snippets ----------------------------------------
local function _expand_snippet(trigger, body)
    -- https://boltless.me/posts/neovim-config-without-plugins-2025/
    local c = vim.fn.nr2char(vim.fn.getchar(0))
    -- Only accept "<C-]>" as a trigger key.
    if c ~= "" then vim.api.nvim_feedkeys(trigger .. c, "i", true)
    -- once expanded, move between "nodes" with <tab>
    else vim.snippet.expand(body)
    end
end
local function _snippet(trigger, body)
    vim.keymap.set("ia", trigger, function() _expand_snippet(trigger, body) end, {})
end
-- organize snippets by file type
local snippet_group = "SnippetGroup"
local file_type = "FileType"
vim.api.nvim_create_augroup(snippet_group, { clear = true })
vim.api.nvim_create_autocmd(file_type, { group = snippet_group, pattern = "python",
    callback = function()
        _snippet("main", 'def main():\n\t${1:print("Hello world")}\n\n\nif __name__ == "__main__":\n\tmain()')
        _snippet("def",  'def ${1:func}(${2}) -> ${3:None}:\n\t${4:body}')
        _snippet("dbg",  'print(f"{$1 = }")')
    end
})
vim.api.nvim_create_autocmd(file_type, { group = snippet_group, pattern = {"c", "h", "cpp"},
    callback = function()
        _snippet("for", "for (size_t ${1:i} = 0; $1 < ${2:n}; ++$1){\n\t$3\n}")
        _snippet("ifn", '#ifndef ${1:NAME}\n#define $1 $2\n$3\n#endif // $1')
        -- typedef struct
    end
})
---------------------------------- colorscheme ---------------------------------
vim.opt.termguicolors = true
vim.cmd [[ colorscheme default ]]
vim.api.nvim_set_hl(0, "Type",           { fg   = "Yellow2" })
vim.api.nvim_set_hl(0, "Identifier",     { link = "@variable" })
vim.api.nvim_set_hl(0, "pythonOperator", { link = "Statement" })
vim.api.nvim_set_hl(0, "pythonInclude",  { link = "Statement" })
vim.api.nvim_set_hl(0, "SpecialComment", { link = "Comment" })

------------------------------- here be plugins -------------------------------
vim.api.nvim_set_hl(0, "@type.builtin",  { link = "Type" })
vim.api.nvim_set_hl(0, "Boolean",        { link = "Type" })
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath, 
    })
end
-- disable treesitter on large files
local function should_disable_ts(bufnr) return vim.api.nvim_buf_line_count(bufnr) > 50000 end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup {
    { 
        "nvim-treesitter/nvim-treesitter", 
        dependencies = {"https://github.com/nvim-treesitter/nvim-treesitter-textobjects", },
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                -- TODO: disable for large files 
                auto_install = false, 
                highlight = { 
                    enable = true,
                    disable = function(lang, bufnr) return should_disable_ts(bufnr) end,
                },
                indent = { 
                    enable = true,
                    disable = function(lang, bufnr) return should_disable_ts(bufnr) end,
                },
                textobjects = {
                    select = { 
                        enable = true,
                        disable = function(lang, bufnr) return should_disable_ts(bufnr) end,
                        lookahead = true,
                        keymaps = {
                            ["if"] = "@function.inner",    ["af"] = "@function.outer",
                            ["ic"] = "@class.inner",       ["ac"] = "@class.outer",
                            ["il"] = "@loop.inner",        ["al"] = "@loop.outer",
                            ["ii"] = "@conditional.inner", ["ai"] = "@conditional.outer",
                        }
                    }, 
                    swap = {
                        enable = true,
                        disable = function(lang, bufnr) return should_disable_ts(bufnr) end,
                        swap_next     = { ["<leader>h"] = "@parameter.inner", },
                        swap_previous = { ["<leader>H"] = "@parameter.inner", },
                    },
                }, 
            } 
        end,
    },
}
