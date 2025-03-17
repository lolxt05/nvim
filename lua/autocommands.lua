local markdown = vim.api.nvim_create_augroup("markdown", { clear = true })
local spelling = vim.api.nvim_create_augroup("spelling", { clear = true })
local spell_keymap = require('spelling').spell_keymap

-- Recognize .md as pandoc
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.md", },
  group = markdown,
  callback = function()
    vim.o.filetype = 'pandoc'
    vim.o.commentstring = '<!--%s-->'
    require('luasnip').filetype_extend("pandoc", { "markdown" })
    vim.o.spell = true
    spell_keymap()
    vim.o.spelllang = 'en,fr'
    vim.o.formatoptions = "qj"
    -- email commands: my/msy to paste the html inside the clipboard
    vim.keymap.set('', '<LocalLeader>msy', ':w !pandoc -f markdown+emoji -t html5 -s | wl-copy --type text/html<CR><CR>',
      { noremap = true, silent = true, desc = "[M]arkdown to [S]ingle page [Y]ank" })
    vim.keymap.set('', '<LocalLeader>my',
      ':w !pandoc -f markdown+emoji --wrap=none -t html5 | wl-copy --type text/html<CR><CR>',
      { noremap = true, silent = true, desc = "[M]arkdown to HTML [Y]ank" })
    vim.keymap.set('', '<LocalLeader>mp', '<Plug>MarkdownPreviewToggle',
      { noremap = true, silent = true, desc = "[M]arkdown [P]review" })
  end
})

-- Spell shortcuts
vim.api.nvim_create_autocmd({ "OptionSet" }, {
  pattern = { "spell" },
  group = spelling,
  callback = spell_keymap
})

-- LaTeX configuration
local texgroup = vim.api.nvim_create_augroup("latex", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "latex", "tex" },
  group = texgroup,
  callback = function()
    -- vimtex configuration
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_view_general_viewer = 'zathura'
    vim.g.maplocalleader = ' '
    -- Legacy shortcut from my vim-latexsuite days
    -- FIX: doesn’t seem to work…
    vim.keymap.set("n", "<Leader>ls", ":VimtexView<CR>",
      { noremap = true, silent = true, desc = 'View [L]atex Document' })

    vim.o.foldmethod = 'expr'
    vim.o.foldexpr = 'vimtex#fold#level(v:lnum)'
    vim.o.foldtext = 'vimtex#fold#text()'
    vim.o.spell = true
    spell_keymap()
    vim.o.spelllang = "en,fr"
  end,
})

-- Typst bindings + spellchecking
local typstgroup = vim.api.nvim_create_augroup("typst", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typst" },
  group = typstgroup,
  callback = function()
    vim.keymap.set('', '<LocalLeader>mp', ':TypstWatch<CR>', { noremap = true, silent = true, desc = "[M]ake [P]review" })
    vim.o.spell = true
    spell_keymap()
    vim.o.spelllang = "fr,en"
  end,
})

-- Jujutsu spellchecking
local jjgroup = vim.api.nvim_create_augroup("jujustu", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "jj" },
  group = jjgroup,
  callback = function()
    vim.o.spell = true
    spell_keymap()
    vim.o.spelllang = "en"
  end,
})
