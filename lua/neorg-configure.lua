--vim.keymap.set('', 'à', '<Nop>', { noremap = true, silent = true })
local neorgroup = vim.api.nvim_create_augroup("neorg", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "norg" },
  group = neorgroup,
  callback = function()
    vim.g.maplocalleader = ' '
    vim.o.conceallevel = 2
    vim.o.foldlevelstart = 99
    vim.keymap.set("n", "<Leader>nr", ":Neorg return<CR>",
      { noremap = true, silent = true, desc = "[N]eorg [R]eturn" })

    -- Neorg Telescope
    vim.keymap.set("n", "<Leader>nh", "<Plug>(neorg.telescope.search_headings)",
      { noremap = true, silent = true, desc = "[N]eorg search [H]eading" })
    vim.keymap.set("n", "<Leader>nb", "<Plug>(neorg.telescope.backlinks.file_backlinks)",
      { noremap = true, silent = true, desc = "[N]eorg file [B]acklinks" })
    vim.keymap.set("n", "<C-l>", "<Plug>(neorg.telescope.insert_link)",
      { noremap = true, silent = true, desc = "Neorg insert [L]ink" })
    -- Tasks
    vim.keymap.set("n", "<LocalLeader>td", "<Plug>(neorg.qol.todo-items.todo.task-done)",
      { noremap = true, silent = true, desc = "[T]ask [D]one" })
    vim.keymap.set("n", "<LocalLeader>tu", "<Plug>(neorg.qol.todo-items.todo.task-undone)",
      { noremap = true, silent = true, desc = "[T]ask [U]ndone" })
    vim.keymap.set("n", "<LocalLeader>tp", "<Plug>(neorg.qol.todo-items.todo.task-pending)",
      { noremap = true, silent = true, desc = "[T]ask [P]ending" })
    vim.keymap.set("n", "<LocalLeader>th", "<Plug>(neorg.qol.todo-items.todo.task-on_hold)",
      { noremap = true, silent = true, desc = "[T]ask on [H]old" })
    vim.keymap.set("n", "<LocalLeader>tc", "<Plug>(neorg.qol.todo-items.todo.task-cancelled)",
      { noremap = true, silent = true, desc = "[T]ask on [C]ancelled" })
    vim.keymap.set("n", "<LocalLeader>tr", "<Plug>(neorg.qol.todo-items.todo.task-recurring)",
      { noremap = true, silent = true, desc = "[T]ask on [R]ecurring" })
    vim.keymap.set("n", "<LocalLeader>ti", "<Plug>(neorg.qol.todo-items.todo.task-important)",
      { noremap = true, silent = true, desc = "[T]ask on [I]mportant" })
  end,
})

local function live_grep_neorg()
  local neorg_root = '~/Sync/neorg' -- TODO: get it from neorg
  require('telescope.builtin').live_grep {
    cwd = neorg_root,
  }
end

-- document existing key chains
require('which-key').add {
  { "<leader>l",   group = "neorg [L]ist" },
  { "<leader>l_",  hidden = true },
  { "<leader>t",   group = "neorg [T]asks" },
  { "<leader>n",   group = "[N]eorg" },
  { "<leader>n_",  hidden = true },
  { "<leader>ne",  group = "[N]eorg [E]xport" },
  { "<leader>ne_", hidden = true },
}

vim.keymap.set("n", "<Leader>ni", ":Neorg index<CR>",
  { noremap = true, silent = true, desc = "[N]eorg [I]ndex" })
vim.keymap.set("n", "<Leader>nm", ":Neorg inject-metadata<CR>",
  { noremap = true, silent = true, desc = "[N]eorg insert [M]etadata" })
vim.keymap.set("n", "<Leader>nj", ":Neorg journal toc open<CR>",
  { noremap = true, silent = true, desc = "[N]eorg [J]ournal" })
vim.keymap.set("n", "<Leader>nt", ":Neorg journal today<CR>",
  { noremap = true, silent = true, desc = "[N]eorg [T]oday" })
vim.keymap.set("n", "<Leader>ns", ":Neorg journal tomorrow<CR>",
  { noremap = true, silent = true, desc = "Neorg  tomorrow" })
vim.keymap.set("n", "<Leader>ny", ":Neorg journal yesterday<CR>",
  { noremap = true, silent = true, desc = "[N]eorg [Y]esterday" })
vim.keymap.set("n", "<Leader>neo", ":e /tmp/neorg-export.md<CR>",
  { noremap = true, silent = true, desc = "[N]eorg [E]xport [O]pen" })
vim.keymap.set("n", "<Leader>nee", ":Neorg export to-file /tmp/neorg-export.md<CR>",
  { noremap = true, silent = true, desc = "[N]eorg [E]xport Predefined" })
vim.keymap.set("n", "<Leader>nef", ":Neorg export to-file ",
  { noremap = true, silent = true, desc = "[N]eorg [E]xport [F]ile" })
vim.keymap.set("n", "<Leader>nl", "<Plug>(neorg.telescope.find_linkable)",
  { noremap = true, silent = true, desc = "[N]eorg find [L]inkable" })
vim.keymap.set("n", "<Leader>nf", "<Plug>(neorg.telescope.find_norg_files)",
  { noremap = true, silent = true, desc = "[N]eorg find [F]ile" })
vim.keymap.set("n", "<Leader>n/", live_grep_neorg,
  { noremap = true, silent = true, desc = "[N]eorg Live Grep" })
