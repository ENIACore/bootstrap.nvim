--[[
-- @TODO@ Add better styling and top and bottom buffers
--]]
vim.keymap.set("n", "<leader>ll", function()
	local buf = vim.api.nvim_create_buf(false, true) -- Create scratchpad buffer
	vim.bo[buf].filetype = "lua" -- Set buffer to be lua
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" }) -- Seed buffer with a blank first line for top padding

	local width = math.floor(vim.o.columns * 0.6)
	local height = math.floor(vim.o.lines * 0.4)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
		title = " Lua scratchpad  <CR> run & yank ",
		title_pos = "center",
	})

	vim.wo[win].statuscolumn = " " -- 1 space left-margin padding
	vim.wo[win].winhighlight = "FloatBorder:TelescopeBorder" -- Match Telescope find_files border color

	local function run_and_yank()
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local code = table.concat(lines, "\n")
		local output_lines = {}
		local orig_print = print
		print = function(...)
			local args = {}
			for i = 1, select("#", ...) do
				args[i] = tostring(select(i, ...))
			end
			table.insert(output_lines, table.concat(args, "\t"))
		end
		local ok, err = pcall(function()
			local fn, load_err = load(code)
			if not fn then
				error(load_err)
			end
			local result = fn()
			if result ~= nil then
				table.insert(output_lines, tostring(result))
			end
		end)
		print = orig_print
		if not ok then
			table.insert(output_lines, "Error: " .. tostring(err))
		end
		local result_str = table.concat(output_lines, "\n")
		vim.fn.setreg("+", result_str)
		vim.fn.setreg("y", result_str)
		vim.api.nvim_win_close(win, true)
		vim.notify("Copied: " .. result_str, vim.log.levels.INFO)
	end

	vim.keymap.set("n", "<CR>", run_and_yank, { buffer = buf })
	vim.keymap.set("i", "<CR>", function()
		vim.cmd("stopinsert")
		run_and_yank()
	end, { buffer = buf })

	for _, key in ipairs({ "q", "<Esc>" }) do
		vim.keymap.set("n", key, function()
			vim.api.nvim_win_close(win, true)
		end, { buffer = buf })
	end

	-- Start in insert mode, cursor after the blank padding line
	vim.schedule(function()
		vim.cmd("startinsert")
	end)
end, { desc = "Lua scratchpad → clipboard" })
