--[[
-- Autogenerate docs on startup and auto close on q
--]]
vim.cmd('helptags ' .. vim.fn.stdpath('config') .. '/doc')
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
end,})
