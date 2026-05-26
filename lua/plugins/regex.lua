--[[
return {
  {
    dir = "~/Desktop/projects/regex.nvim",
    name = "regex.nvim",
    dev = true, -- tells Lazy this is a development plugin
    lazy = false,

    config = function()
        require("regex")
    end
  }
}
--]]
return {}
