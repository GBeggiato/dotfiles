vim.g.mapleader        = " "
vim.g.maplocalleader   = " "
vim.opt.swapfile       = false
vim.opt.shada          = "" -- forgets marks, registers, ...  Only for performance at startup, remove freely
vim.opt.mouse          = "" -- fully disable to avoid touchpad issues
vim.opt.signcolumn     = "yes:1"
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.guicursor      = "a:block,a:blinkwait0" -- cursor always block, no blink
vim.opt.wrap           = true
vim.opt.expandtab      = true
vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.colorcolumn    = "80"
vim.opt.clipboard      = "unnamedplus" -- sync vim and standard copy register
vim.opt.scrolloff      = 99 -- cursor always mid-screen
vim.opt.virtualedit    = "block" -- visual mode past end of line
vim.g.netrw_liststyle  = 3 -- default file explorer (Netrw). 0: base, 1: date, 3: tree
vim.opt.pumheight      = 3
vim.o.timeoutlen       = 300

------------------------------- [[remap land]] (M = meta = alt key) -------------------------------
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
vim.opt.path = vim.opt.path + "**"
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
vim.keymap.set("v", "<leader>p", "\"_dP")
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
-- remove trailing whitespace
vim.api.nvim_create_user_command('TRimTrailingWhiteSpace', function() vim.cmd([[%s/\s\+$//e]]) end, {})
-- inverse of [J]oin
vim.keymap.set("v", "<leader>j", ":substitute/ /<C-v><CR>/gc<CR>a")

-- [[ Highlight on yank ]]
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank() end,
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    pattern = "*",
})

-- [A]lign
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
-- [A]lign on = (or other) sign
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
_snippet("for",  "for (size_t ${1:i} = 0; $1 < ${2:n}; ++$1){\n\t$3\n}"     ) -- c for loop
_snippet("pymain", 'def main():\n\t$1\n\nif __name__ == "__main__":\n\tmain()') -- python main

------------------------------- colorscheme: POND -------------------------------
vim.opt.termguicolors = true
vim.cmd [[ colorscheme default ]] -- also evening
vim.api.nvim_set_hl(0, "Normal", {         fg = "NvimLightGrey2", bg = "Black"})
vim.api.nvim_set_hl(0, "Statement", {      fg =  "#aa89f7" }) -- tokyonight magenta="#bb9af7
vim.api.nvim_set_hl(0, "String", {         fg = "LightGreen" })
vim.api.nvim_set_hl(0, "Type", {           fg = "Lime" })
vim.api.nvim_set_hl(0, "Function", {       fg = "NvimLightBlue" })
vim.api.nvim_set_hl(0, "Constant", {       fg = "NvimLightCyan" })
vim.api.nvim_set_hl(0, "Pmenu", {          fg = "NvimLightGrey2", bg = "Indigo" })
vim.api.nvim_set_hl(0, "PmenuSel", {       fg = "Black",          bg = "DarkYellow" })
vim.api.nvim_set_hl(0, "Identifier", {     link = "@variable" }) -- properties, struct fields
vim.api.nvim_set_hl(0, "LineNr", {         link = "Comment" })
vim.api.nvim_set_hl(0, "SpecialComment", { link = "Comment" })
vim.api.nvim_set_hl(0, "pythonInclude", {  link = "Statement" })
vim.api.nvim_set_hl(0, "pythonOperator", { link = "Statement" })
vim.api.nvim_set_hl(0, "Boolean", {        link = "Function" })
vim.api.nvim_set_hl(0, "StatusLine", {     link = "PMenu" })
vim.api.nvim_set_hl(0, "Search", {         link = "PMenu" })
vim.api.nvim_set_hl(0, "CurSearch", {      link = "PmenuSel" })
