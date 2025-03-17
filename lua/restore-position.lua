-- Restore cursor position
-- Adapted from https://stackoverflow.com/a/72939989/10585637
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_exec2('silent! normal! g`"zv', {})
    end,
})
