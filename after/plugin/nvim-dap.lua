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

local dap    = require('dap')
local dapui  = require('dapui')
local widgets = require('dap.ui.widgets')

-- ── Core controls ──────────────────────────────────────────────────────────
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint,  { desc = 'DAP: Toggle breakpoint' })
vim.keymap.set('n', '<leader>dB', function()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end,                                                        { desc = 'DAP: Conditional breakpoint' })
vim.keymap.set('n', '<leader>dl', function()
    dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end,                                                        { desc = 'DAP: Log point' })
vim.keymap.set('n', '<leader>dc', dap.continue,           { desc = 'DAP: Continue' })
vim.keymap.set('n', '<leader>di', dap.step_into,          { desc = 'DAP: Step into' })
vim.keymap.set('n', '<leader>do', dap.step_over,          { desc = 'DAP: Step over' })
vim.keymap.set('n', '<leader>dO', dap.step_out,           { desc = 'DAP: Step out' })
vim.keymap.set('n', '<leader>dr', dap.run_to_cursor,      { desc = 'DAP: Run to cursor' })
vim.keymap.set('n', '<leader>dR', dap.restart,            { desc = 'DAP: Restart' })
vim.keymap.set('n', '<leader>dt', dap.terminate,          { desc = 'DAP: Terminate' })
vim.keymap.set('n', '<leader>dp', dap.pause,              { desc = 'DAP: Pause' })

-- ── Breakpoint management ──────────────────────────────────────────────────
vim.keymap.set('n', '<leader>dx', dap.clear_breakpoints,  { desc = 'DAP: Clear all breakpoints' })

-- ── UI ─────────────────────────────────────────────────────────────────────
vim.keymap.set('n', '<leader>du', dapui.toggle,           { desc = 'DAP: Toggle UI' })
vim.keymap.set('n', '<leader>dq', dapui.close,          { desc = 'DAP: Close all windows' })

-- ── Floating widgets (open inline, close with q) ───────────────────────────
vim.keymap.set('n', '<leader>dh', widgets.hover,          { desc = 'DAP: Hover value' })
-- vim.keymap.set('v', '<leader>dh', widgets.visual_hover,   { desc = 'DAP: Hover selection' })
vim.keymap.set('n', '<leader>dS', function()
    widgets.centered_float(widgets.scopes)
end,                                                        { desc = 'DAP: Scopes (float)' })
vim.keymap.set('n', '<leader>df', function()
    widgets.centered_float(widgets.frames)
end,                                                        { desc = 'DAP: Frames/stack (float)' })

-- ── REPL ───────────────────────────────────────────────────────────────────
vim.keymap.set('n', '<leader>d:', dap.repl.toggle,        { desc = 'DAP: Toggle REPL' })
