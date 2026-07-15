-- function-preproc, const-type, string, statement, comment
local current_colorscheme = 7
vim.api.nvim_create_user_command(
    'ColoRefresh',
    function(opts)
        if current_colorscheme == 0 then
            vim.cmd.colorscheme("default")
            vim.api.nvim_set_hl(0, "Type",           {link = "DiagnosticWarn"})
            vim.api.nvim_set_hl(0, "PreProc",        {link = "Identifier"})
            vim.api.nvim_set_hl(0, "Constant",       {link = "Identifier"})
        elseif current_colorscheme == 1 then
            vim.cmd.colorscheme("lunaperche")
            vim.api.nvim_set_hl(0, "Function",       {link = "PreProc"})
            vim.api.nvim_set_hl(0, "Special",        {link = "Normal"})
        elseif current_colorscheme == 2 then
            -- poor man's gruber darker (https://github.com/rexim/gruber-darker-theme)
            vim.cmd.colorscheme("quiet")
            vim.api.nvim_set_hl(0, "Statement",      {fg = "Yellow"})
            vim.api.nvim_set_hl(0, "String",         {fg = "LimeGreen"})
            vim.api.nvim_set_hl(0, "Comment",        {fg = "DarkOrange"})
            vim.api.nvim_set_hl(0, "@markup.raw",    {fg = "Blue"})
            vim.api.nvim_set_hl(0, "Function",       {fg = "#9e95c7"}) -- wisteria
            vim.api.nvim_set_hl(0, "Type",           {fg = "#95a99f"}) -- quartz
            vim.api.nvim_set_hl(0, "PreProc",        {fg = "#95a99f"})
            vim.api.nvim_set_hl(0, "Constant",       {fg = "#95a99f"})
            vim.api.nvim_set_hl(0, "Number",         {link = "Normal"})
        elseif current_colorscheme == 3 then
            vim.cmd.colorscheme("habamax")
            vim.api.nvim_set_hl(0, "Special", {link = "Normal"})
        elseif current_colorscheme == 4 then
            vim.cmd("colorscheme darkblue")
            vim.api.nvim_set_hl(0, "MatchParen", {fg = "LimeGreen", bg="DarkGreen"})
        elseif current_colorscheme == 5 then
            vim.cmd("colorscheme zaibatsu")
            vim.api.nvim_set_hl(0, "MatchParen", {fg = "LimeGreen", bg="DarkGreen"})
        elseif current_colorscheme == 6 then
            vim.cmd("colorscheme pablo")
            vim.api.nvim_set_hl(0, "Special", {link = "Normal"})
        elseif current_colorscheme == 7 then
            vim.cmd("colorscheme quiet")
            vim.api.nvim_set_hl(0, "String",    {fg = "NvimLightGreen"})
            vim.api.nvim_set_hl(0, "Statement", {fg = "DarkOrange"})
            vim.api.nvim_set_hl(0, "Function",  {fg = "DarkYellow"})
            vim.api.nvim_set_hl(0, "PreProc",   {link = "Function"})
            vim.api.nvim_set_hl(0, "Constant",  {fg = "#ff00af"})
            vim.api.nvim_set_hl(0, "Type",      {fg = "#ff00af"})
        elseif current_colorscheme == 8 then
            vim.api.nvim_set_hl(0, "String",    {fg = "NvimLightGreen"})
            vim.api.nvim_set_hl(0, "Statement", {fg = "DarkOrange", bold=true})
            vim.api.nvim_set_hl(0, "Function",  {fg = "DarkOrange"})
            vim.api.nvim_set_hl(0, "PreProc",   {link = "Function"})
            vim.api.nvim_set_hl(0, "Constant",  {link = "MatchParen"})
            vim.api.nvim_set_hl(0, "Type",      {link = "MatchParen"})
        end
        vim.api.nvim_set_hl(0, "SpecialComment", {link = "Comment"})
        current_colorscheme = (current_colorscheme + 1) % 9
    end,
    {}
)
vim.cmd("ColoRefresh")



vim.cmd.colorscheme("lunaperche")
vim.api.nvim_set_hl(0, "SpecialComment", {link = "Comment"})
vim.api.nvim_set_hl(0, "Statement",      {link = "Constant"})
for _, group in ipairs({"Special", "Identifier", "Type", "Number", "Function"}) do
    vim.api.nvim_set_hl(0, group,        {link = "PreProc"})
end


-- light scheme
vim.cmd.colorscheme("morning")
vim.cmd.colorscheme("quiet")
vim.api.nvim_set_hl(0, "Statement",      {fg = "Black", bold=true})
vim.api.nvim_set_hl(0, "Constant",       {link = "Statement"})
vim.api.nvim_set_hl(0, "String",         {fg = "DarkGreen"})
vim.api.nvim_set_hl(0, "Comment",        {link = "VertSplit"})
vim.api.nvim_set_hl(0, "SpecialComment", {link = "VertSplit"})
for _, group in ipairs({"Identifier", "Special", "PreProc", "Type", "Number", "Function"}) do
    vim.api.nvim_set_hl(0, group,        {fg = "Blue"})
end




vim.api.nvim_create_user_command("ColoLight",
    function() 
        vim.cmd.colorscheme("morning")
        vim.cmd.colorscheme("quiet")
        vim.api.nvim_set_hl(0, "Statement",      {fg="Black", bold=true})
        vim.api.nvim_set_hl(0, "String",         {fg="Green", bold=true})
        vim.api.nvim_set_hl(0, "Constant",       {link="Statement"})
        vim.api.nvim_set_hl(0, "Comment",        {link="VertSplit"})
        vim.api.nvim_set_hl(0, "SpecialComment", {link="Comment"})
        for _, group in ipairs({"Identifier", "Special", "PreProc", "Type", "Number", "Function"}) do
            vim.api.nvim_set_hl(0, group,        {fg="Blue"})
        end
    end, {}
)
vim.api.nvim_create_user_command("ColoDark",
    function() 
        vim.cmd.colorscheme("habamax")
        vim.api.nvim_set_hl(0, "Statement",      {link="Constant"})
        vim.api.nvim_set_hl(0, "String",         {fg="DarkYellow"})
        vim.api.nvim_set_hl(0, "SpecialComment", {link="Comment"})
        for _, group in ipairs({"Special", "PreProc", "Type", "Number", "Function"}) do
            vim.api.nvim_set_hl(0, group,        {link="Identifier"})
        end
    end, {}
)
vim.cmd("ColoDark")
