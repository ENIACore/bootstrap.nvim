vim.treesitter.start()

-- Required for Obsidian's UI features (checkboxes, hidden markdown syntax, etc.)
vim.opt_local.conceallevel = 2

-- Opaque background while reading markdown. Global Normal stays bg=none
-- (kitty shows through) everywhere else; this only overrides the current
-- window via winhighlight, forcing a solid black with no transparency.
vim.api.nvim_set_hl(0, "MarkdownOpaqueBg", { bg = "#24283c", fg = "#c0caf5" })
-- render-markdown.nvim draws heading icons in the sign column using
-- RenderMarkdownSign (linked to SignColumn by default), which winhighlight
-- doesn't remap for extmark-applied sign highlights, so override directly.
vim.api.nvim_set_hl(0, "RenderMarkdownSign", { bg = "#24283c" })

local function set_opaque_bg()
	vim.wo.winhighlight = "Normal:MarkdownOpaqueBg,NormalNC:MarkdownOpaqueBg,EndOfBuffer:MarkdownOpaqueBg"
end

local function clear_opaque_bg()
	vim.wo.winhighlight = ""
end

set_opaque_bg()

vim.api.nvim_create_autocmd("BufEnter", { buffer = 0, callback = set_opaque_bg })
vim.api.nvim_create_autocmd("BufLeave", { buffer = 0, callback = clear_opaque_bg })
