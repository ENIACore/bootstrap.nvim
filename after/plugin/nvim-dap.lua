--[[
-- Automatically ensures debug servers are installed and enabled
--]]
local registry = require('utils.registry')

local debuggers = {
    'java-debug-adapter',
    'java-test',
    -- 'debugpy',         -- Python
    -- 'js-debug-adapter' -- JS/TS
}

registry:install_pkg_list(debuggers)

local dap = require('dap')
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP: Toggle breakpoint' })
vim.keymap.set('n', '<leader>dc', dap.continue,          { desc = 'DAP: Continue' })
vim.keymap.set('n', '<leader>di', dap.step_into,         { desc = 'DAP: Step into' })
vim.keymap.set('n', '<leader>do', dap.step_over,         { desc = 'DAP: Step over' })
vim.keymap.set('n', '<leader>dO', dap.step_out,          { desc = 'DAP: Step out' })
vim.keymap.set('n', '<leader>dt', dap.terminate,         { desc = 'DAP: Terminate' })

local dapui = require('dapui')
vim.keymap.set('n', '<leader>du', function() dapui.toggle() end, { desc = 'DAP: Toggle UI' })
