return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "notes",
				path = "~/Documents/notes",
			},
		},

		-- Use telescope for pickers (repo already depends on nvim-telescope/telescope.nvim)
		picker = {
			name = "telescope.nvim",
		},

		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},

		daily_notes = {
			folder = "daily",
			date_format = "%Y-%m-%d",
		},

		disable_frontmatter = false,

		-- Needed for Obsidian's UI features (checkboxes, hidden markdown syntax, etc.)
		ui = {
			enable = true,
		},

		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
		},
	},
	keys = {
		{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian: new note" },
		{ "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Obsidian: open in app" },
		{ "<leader>ofs", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: search" },
		{ "<leader>ofq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: quick switch" },
		{ "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian: insert template" },
		{ "<leader>ol", "<cmd>ObsidianLink<cr>", mode = "v", desc = "Obsidian: link selection" },
		{ "<leader>obl", "<cmd>ObsidianBacklinks<cr>", desc = "Obsidian: show backlinks" },
		{ "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: open today's daily note" },
		{ "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Obsidian: open yesterday's daily note" },
		{ "<leader>otg", "<cmd>ObsidianTags<cr>", desc = "Obsidian: browse tags" },
	},
}
