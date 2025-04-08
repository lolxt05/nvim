local map_list = {
  -- ["w|"] = ":vsplit", ["w-"] = ":split", -- w| / w- pour créer des splits verticaux et horizontaux
  -- ["ge"] = ":bprevious", ["gn"] = ":bnext",
  ["W"] = ":w",
  ["<C-t>"] = ":tabnew",
}

local keymap = vim.keymap.set

for key, binding in pairs(map_list) do
  keymap("n", key, binding .. "<CR>", { noremap = true, silent = true })
end

-- [[ kickstart.nvim ]]
-- Keymaps for better default experience
-- See `:help remap()`
keymap({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

keymap({ "n", "v" }, "<Leader>y", '"+y', { noremap = true, silent = true, desc = "[Y]ank to system clipboard" })
keymap({ "n", "v" }, "<Leader>Y", '"+yg_', { noremap = true, silent = true, desc = "[Y]ank line to system clipboard" })
keymap({ "n", "v" }, "<Leader>p", '"+p', { noremap = true, silent = true, desc = "[P]ast from system clipboard" })

-- z0…z9 to open folds to a certain level
for i = 0, 9 do
  keymap('n', 'z' .. i, ':set fdl=' .. i .. '<CR>', { noremap = true, silent = false })
end

-- in :terminal esc exits edit mode
keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- Markdown scratchpads
require('which-key').add({
  { "<leader>m",   group = "[M]arkdown" },
  { "<leader>m_",  hidden = true },
  { "<leader>sl",  group = "[S]pell[Lang]" },
  { "<leader>sl_", hidden = true },
})

-- Markdown temp files
keymap('n', '<leader>mn', ':e ~/tmp/scratch.md<CR>', { desc = '[M]arkdown [N]ew', noremap = true, silent = true })
keymap('n', '<leader>me', ':e ~/tmp/scratch-fr.md<CR>',
  { desc = '[M]arkdown new Fr[e]nch', noremap = true, silent = true })

-- Spellchecking
keymap('n', '<leader>st', ':set spell!<CR>', { desc = "Toggle [S]pellcheck", silent = true, noremap = true })
keymap('n', '<leader>sle', ':set spelllang=en<CR>',
  { desc = "Set [S]pell[L]ang to [E]nglish", silent = true, noremap = true })
keymap('n', '<leader>slf', ':set spelllang=fr<CR>',
  { desc = "Set [S]pell[L]ang to [F]rench", silent = true, noremap = true })

-- Toggle hlsearch
keymap({ 'n', 'v' }, '<C-l>', ':set hlsearch!<CR>', { silent = true, noremap = true })

-- [[ Some standard behaviour changes ]]
-- Y is mapped to y$, remap to yg_
keymap('n', 'Y', 'yg_', { noremap = true, silent = true, desc = '[Y]ank the line' })
-- {>,<} preserve the selection
keymap('v', '>', '>gv', { noremap = true, silent = true })
keymap('v', '<', '<gv', { noremap = true, silent = true })

keymap('n', '<leader>wt', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = "Toggle Nvim tree" })
keymap('n', '<leader>wc', ':NvimTreeCollapseKeepBuffers<CR>', { noremap = true, silent = true, desc = "Nvim tree collapes on all folder but only keep folder open that have buffers opened in them" })
keymap('n', '<leader>wl', ':NvimTreeRefresh<CR>', { noremap = true, silent = true, desc = "Refresh the nvim tree" })
