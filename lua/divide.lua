local divide_config = require("divide.config")
local divide_generator = require("divide.generator")

local M = {}

--- Setup function for package managers.
---@param config table config for
M.setup = function(config)
	-- Merge config.
	divide_config = vim.tbl_deep_extend("force", divide_config, config or {})
end

--- Display plugin config info.
M.info = function()
	local divide_info = "Current comment divider config:"
	divide_info = divide_info .. "\n" .. vim.inspect(divide_config)
	print(divide_info)
end

--- Display filetype for current buffer.
M.filetype = function()
	local curr_filetype = vim.api.nvim_buf_get_option(0, "filetype")
	print("Current buffer filetype: " .. curr_filetype)
end

--- Generate comment divider subheader.
M.subheader = function()
	divide_generator.subheader(divide_config)
end

--- Generate comment divider header.
M.header = function()
	divide_generator.header(divide_config)
end

--- Generate comment divider.
M.divider = function()
	divide_generator.divider(divide_config)
end

--- Reload module for development.
M.reload = function()
	local reload = require("plenary.reload").reload_module
	reload("divide", true)
end

return M
