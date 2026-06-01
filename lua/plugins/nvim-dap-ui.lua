return {
	"rcarriga/nvim-dap-ui",
	-- nvim-nio is required by dap-ui for async handling of DAP events
	-- (process spawning, stepping, output streaming etc.)
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()

		-- Automatically open the UI when a debug session starts,
		-- and close it when the session ends or the process exits
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		-- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
		-- dap.listeners.before.event_exited['dapui_config'] = dapui.close
	end,
}
