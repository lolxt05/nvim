-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this

-- Light colorscheme
vim.o.background = "dark"

-- general purpose options
local set_true = { 'title', 'relativenumber', 'ruler', 'modeline',
  'autoread', 'cursorline', 'cursorcolumn',
  'incsearch',
  'showcmd', 'showmatch', 'lazyredraw', 'linebreak', 'wrap',
  'wildmenu', 'wildignorecase', 'showfulltag', }
vim.o.colorcolumn = '+1'
for _, o in ipairs(set_true) do
  vim.o[o] = true
end

-- folds
vim.g.ip_skipfold = true

-- window management
vim.o.tw = 80
vim.o.winwidth = 88
vim.o.scrolloff = 10
vim.cmd "set formatoptions-=t"

-- Make some typographic chars visible
vim.opt.listchars:append({ nbsp = "·", trail = "¤", eol = '↲' })
vim.o.list = true
