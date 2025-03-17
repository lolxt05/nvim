local keyunmap = function(mode, binding)
  if vim.fn.maparg(binding, mode) ~= "" then
    vim.keymap.del(mode, binding)
  end
end

local M = {}

M.spell_keymap = function()
  if vim.o.spell == true then
    vim.keymap.set("n", "<Leader>i", "mzl[s1z=`z", { noremap = true, silent = true, desc = "f[I]x typo under cursor" })
    vim.keymap.set("n", "à", "]s", { noremap = true, silent = true, desc = "Go to the next typo" })
  else
    keyunmap("n", "<Leader>i")
    keyunmap("n", "à")
  end
end

return M
