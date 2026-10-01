--[[
-- Automatically ensures debug servers are installed and enabled
--]]
local registry = require("utils.registry")
local debuggers = {
	"java-debug-adapter",
	"java-test",
	-- 'debugpy',         -- Python
	-- 'js-debug-adapter' -- JS/TS
}
registry:install_pkg_list(debuggers)

local dap = require("dap")
local dapui = require("dapui")
local widgets = require("dap.ui.widgets")
local default_dapui_layouts = {
	{
		elements = {
			{ id = "scopes", size = 0.25 },
			{ id = "breakpoints", size = 0.25 },
			{ id = "stacks", size = 0.25 },
			{ id = "watches", size = 0.25 },
		},
		size = 40,
		position = "left",
	},
	{
		elements = { "repl", "console" },
		size = 10,
		position = "bottom",
	},
}
local dapui_layout = 0
local custom_dapui_windows = {}
local previous_laststatus

local function dapui_layout_is_open()
	for _, layout in ipairs(require("dapui.windows").layouts) do
		if layout:is_open() then
			return true
		end
	end
	return false
end

local function sync_dapui_statusline()
	if dapui_layout ~= 0 or dapui_layout_is_open() then
		if previous_laststatus == nil then
			previous_laststatus = vim.o.laststatus
		end
		vim.o.laststatus = 0
	elseif previous_laststatus ~= nil then
		vim.o.laststatus = previous_laststatus
		previous_laststatus = nil
	end
end

local function close_custom_dapui_layout()
	for _, win in pairs(custom_dapui_windows) do
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
	custom_dapui_windows = {}
	dapui.close()
	dapui.setup({ layouts = vim.deepcopy(default_dapui_layouts) })
	dapui_layout = 0
	sync_dapui_statusline()
end

local function toggle_custom_dapui_layout()
	if dapui_layout == 2 then
		close_custom_dapui_layout()
		return
	end
	if dapui_layout == 1 then
		dapui.close()
		dapui_layout = 0
	end

	local code_win = vim.api.nvim_get_current_win()
	local function is_source_window(win)
		local buf = vim.api.nvim_win_get_buf(win)
		local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
		return buftype == "" and not filetype:match("^dapui")
	end

	if not is_source_window(code_win) then
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if is_source_window(win) then
				code_win = win
				break
			end
		end
	end
	if not is_source_window(code_win) then
		vim.notify("Open a source buffer before opening the custom DAP layout", vim.log.levels.WARN)
		return
	end

	local source_buf = vim.api.nvim_win_get_buf(code_win)
	dapui.close()
	dapui.setup({
		layouts = {
			{
				elements = {
					{ id = "scopes", size = 0.25 },
					{ id = "breakpoints", size = 0.25 },
					{ id = "stacks", size = 0.25 },
					{ id = "watches", size = 0.25 },
				},
				size = 0.6,
				position = "left",
			},
		},
	})
	dapui.open({ layout = 1, reset = true })
	vim.api.nvim_set_current_win(code_win)
	vim.api.nvim_win_set_buf(code_win, source_buf)

	custom_dapui_windows = {}
	dapui_layout = 2
	vim.api.nvim_set_current_win(code_win)
	sync_dapui_statusline()
end

-- ── Core controls ──────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP: Conditional breakpoint" })
vim.keymap.set("n", "<leader>dl", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "DAP: Log point" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: Continue" })
vim.keymap.set("n", "<leader>da", function()
	local host = vim.fn.input("Java debug host: ", "127.0.0.1")
	if host == "" then
		vim.notify("Java debug attach cancelled: host is required", vim.log.levels.WARN)
		return
	end

	local port_input = vim.fn.input("Java debug port: ", "5005")
	if port_input == "" then
		vim.notify("Java debug attach cancelled: port is required", vim.log.levels.WARN)
		return
	end
	local port = tonumber(port_input)
	if not port or port % 1 ~= 0 or port < 1 or port > 65535 then
		vim.notify("Invalid Java debug port: " .. port_input, vim.log.levels.ERROR)
		return
	end

	dap.run({
		type = "java",
		request = "attach",
		name = "Java: Attach to " .. host .. ":" .. port,
		hostName = host,
		port = port,
	})
end, { desc = "DAP: Attach to Java host/port" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP: Step into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP: Step over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "DAP: Step out" })
vim.keymap.set("n", "<leader>dr", dap.run_to_cursor, { desc = "DAP: Run to cursor" })
vim.keymap.set("n", "<leader>dR", dap.restart, { desc = "DAP: Restart" })
vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "DAP: Terminate" })
vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "DAP: Pause" })

-- ── Breakpoint management ──────────────────────────────────────────────────
vim.keymap.set("n", "<leader>dx", dap.clear_breakpoints, { desc = "DAP: Clear all breakpoints" })

-- ── UI ─────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>du", function()
	if dapui_layout == 2 then
		close_custom_dapui_layout()
		return
	end
	if dapui_layout == 1 then
		dapui.close()
		dapui_layout = 0
	else
		dapui.open()
		dapui_layout = 1
	end
	sync_dapui_statusline()
end, { desc = "DAP: Toggle UI" })
vim.keymap.set("n", "<leader>dU", toggle_custom_dapui_layout, { desc = "DAP: Toggle custom wide layout" })
vim.keymap.set("n", "<leader>dq", function()
	if dapui_layout == 2 then
		close_custom_dapui_layout()
	else
		dapui.close()
		dapui_layout = 0
		sync_dapui_statusline()
	end
end, { desc = "DAP: Close all windows" })

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
	sync_dapui_statusline()
end

-- ── Floating widgets (open inline, close with q) ───────────────────────────
vim.keymap.set("n", "<leader>dh", widgets.hover, { desc = "DAP: Hover value" })
-- vim.keymap.set('v', '<leader>dh', widgets.visual_hover,   { desc = 'DAP: Hover selection' })
vim.keymap.set("n", "<leader>dS", function()
	widgets.centered_float(widgets.scopes)
end, { desc = "DAP: Scopes (float)" })
vim.keymap.set("n", "<leader>df", function()
	widgets.centered_float(widgets.frames)
end, { desc = "DAP: Frames/stack (float)" })

-- ── REPL ───────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>d:", dap.repl.toggle, { desc = "DAP: Toggle REPL" })
