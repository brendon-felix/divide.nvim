local generator = {}

--- Generate comment divider line.
---@param comment string current buffer conetnt.
---@param bufLineLength number the length of current buffer line.
---@param length number the total length of the comment divider.
---@param language_config table the language specific comment divider config.
---@param endLength number the length of line_end.
---@param seperatorLength number the length of character.
---@param startLength number the length of line_start.
---@return string lineStr the generated comment divider line.
local function generate_subheader(
	comment,
	bufLineLength,
	length,
	language_config,
	endLength,
	seperatorLength,
	startLength
)
	-- Calculate the left and right seperatorLength.
	-- Half of the seperator length.
	local seperatorLengthHalf = math.floor((length - startLength - endLength - 4 - bufLineLength) / 2)
	-- Number of seperator per half.
	local seperatorNum = math.floor(seperatorLengthHalf / seperatorLength)
	-- Number of spaces in the center.
	local centerSpace = length - startLength - endLength - 2 - seperatorNum * 2 * seperatorLength - bufLineLength
	local leftCenterSpace = math.floor(centerSpace / 2)
	local rightCenterSpace = math.floor((centerSpace + 1) / 2)

	-- Construct the comment line.
	local lineStr = ""
	-- Start
	lineStr = lineStr .. language_config.line_start .. " "
	-- Left seperator.
	for _ = 1, seperatorNum do
		lineStr = lineStr .. language_config.character
	end
	-- Left center space.
	for _ = 1, leftCenterSpace do
		lineStr = lineStr .. " "
	end
	-- Buffer line text.
	lineStr = lineStr .. comment
	-- Right center space.
	for _ = 1, rightCenterSpace do
		lineStr = lineStr .. " "
	end
	-- Right seperator.
	for _ = 1, seperatorNum do
		lineStr = lineStr .. language_config.character
	end
	-- End
	lineStr = lineStr .. " " .. language_config.line_end
	return lineStr
end

--- Generate a solid divider line.
---@param length number the total length of the comment divider.
---@param language_config table the language specific comment divider config.
---@param endLength number the length of line_end.
---@param seperatorLength number the length of character.
---@param startLength number the length of line_start.
---@return string lineStr the generated comment divider line.
local function generate_solid_line(length, language_config, endLength, seperatorLength, startLength)
	-- Calculate the total seperator length.
	local totalSeperatorLength = length - startLength - endLength - 2
	local seperatorNum = math.floor(totalSeperatorLength / seperatorLength)
	totalSeperatorLength = seperatorNum * seperatorLength
	-- Calculate left and right space.
	local leftSpace = math.floor((length - startLength - endLength - totalSeperatorLength) / 2)
	local rightSpace = math.floor((length - startLength - endLength - totalSeperatorLength + 1) / 2)

	-- Construct the solid line.
	local lineStr = ""
	-- Start.
	lineStr = lineStr .. language_config.line_start
	-- Left space.
	for i = 1, leftSpace do
		lineStr = lineStr .. " "
	end
	-- Seperator.
	for i = 1, seperatorNum do
		lineStr = lineStr .. language_config.character
	end
	-- Right space.
	for i = 1, rightSpace do
		lineStr = lineStr .. " "
	end
	-- End.
	lineStr = lineStr .. language_config.line_end
	return lineStr
end

--- Generated a line of comment wrapped with spaces.
---@param comment string current buffer conetnt.
---@param bufLineLength number the length of current buffer line.
---@param length number the total length of the comment divider.
---@param language_config table the language specific comment divider config.
---@param endLength number the length of line_end.
---@param startLength number the length of line_start.
---@return string lineStr the generated comment divider line.
local function generate_centered_comment(comment, bufLineLength, length, language_config, endLength, startLength)
	-- Calculate left and righ space.
	local leftSpace = math.floor((length - startLength - endLength - bufLineLength) / 2)
	local rightSpace = math.floor((length - startLength - endLength - bufLineLength + 1) / 2)

	-- Construct wrapped line.
	local lineStr = ""
	-- Start.
	lineStr = lineStr .. language_config.line_start
	-- Left space.
	for i = 1, leftSpace do
		lineStr = lineStr .. " "
	end
	-- Buffer line.
	lineStr = lineStr .. comment
	-- Right space.
	for i = 1, rightSpace do
		lineStr = lineStr .. " "
	end
	-- End.
	lineStr = lineStr .. language_config.line_end
	return lineStr
end

--- Generate comment line divider.
---@param config table config for comment generator.
generator.subheader = function(config)
	-- Total length of the comment line.
	local length = config.length
	-- Get current filetype.
	local filetype = vim.api.nvim_get_option_value(0, "filetype")
	-- Get the language config for current filetype.
	local language_config = config.language_config[filetype]
	language_config = language_config or config.default
	-- Length for line components.
	local startLength = string.len(language_config.line_start)
	local seperatorLength = string.len(language_config.character)
	local endLength = string.len(language_config.line_end)

	-- Start a new line.
	-- Get current buffer row number.
	local currentRow = vim.api.nvim_win_get_cursor(0)[1]
	-- Insert lines.
	vim.api.nvim_buf_set_lines(0, currentRow, currentRow, false, { "" })
	vim.api.nvim_win_set_cursor(0, { currentRow + 1, 0 })

	vim.ui.input({ prompt = "Enter the comment here: " }, function(comment)
		if comment == nil then
			vim.api.nvim_buf_set_lines(0, currentRow, currentRow + 1, false, {})
			return
		end
		-- Trim all the white spaces.
		comment = comment:gsub("^%s*(.-)%s*$", "%1")
		-- The length of current buffer line.
		local bufLineLength = comment:len()

		-- Calculate how many characters are needed for minimum seperator.
		-- /* - text - */
		local minSeperatorLength = startLength + endLength + 2 * seperatorLength + 4
		if bufLineLength + minSeperatorLength > length then
			vim.api.nvim_buf_set_lines(0, currentRow, currentRow + 1, false, {})
			print("Comment too long.")
			return
		end
		local lineStr = ""
		if bufLineLength > 0 then
			-- Generate comment divider when bufLineLength > 0.
			lineStr = generate_subheader(
				comment,
				bufLineLength,
				length,
				language_config,
				endLength,
				seperatorLength,
				startLength
			)
		else
			lineStr = generate_solid_line(length, language_config, endLength, seperatorLength, startLength)
		end

		-- Get current buffer row number.
		currentRow = vim.api.nvim_win_get_cursor(0)[1]
		-- Insert lines.
		vim.api.nvim_buf_set_lines(0, currentRow - 1, currentRow, false, { lineStr })
	end)
end

--- Generate comment box divider.
---@param config table config for comment generator.
generator.header = function(config)
	-- Total length of the comment line.
	local length = config.length
	-- Get current filetype.
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	-- Get the language config for current filetype.
	local language_config = config.language_config[filetype]
	language_config = language_config or config.default
	-- Length for line components.
	local startLength = string.len(language_config.line_start)
	local seperatorLength = string.len(language_config.character)
	local endLength = string.len(language_config.line_end)

	-- Start a new line.
	-- Get current buffer row number.
	local currentRow = vim.api.nvim_win_get_cursor(0)[1]
	-- Insert lines.
	vim.api.nvim_buf_set_lines(0, currentRow, currentRow, false, { "" })
	vim.api.nvim_win_set_cursor(0, { currentRow + 1, 0 })

	vim.ui.input({ prompt = "Enter the comment here: " }, function(comment)
		if comment == nil then
			vim.api.nvim_buf_set_lines(0, currentRow, currentRow + 1, false, {})
			return
		end
		-- Trim all the white spaces.
		comment = comment:gsub("^%s*(.-)%s*$", "%1")
		-- The length of current buffer line.
		local bufLineLength = comment:len()

		-- Calculate how many characters are needed for minimum seperator.
		-- /* - text - */
		local minSeperatorLength = startLength + endLength + 2 * seperatorLength + 4
		if bufLineLength + minSeperatorLength > length then
			vim.api.nvim_buf_set_lines(0, currentRow, currentRow + 1, false, {})
			print("Comment too long.")
			return
		end
		-- If the current buffer line is empty, reject the request.
		if bufLineLength == 0 then
			vim.api.nvim_buf_set_lines(0, currentRow, currentRow + 1, false, {})
			print("Empty line.")
			return
		end

		-- Insert lines.
		local insert_lines = {}
		-- Top solid line.
		table.insert(
			insert_lines,
			generate_solid_line(length, language_config, endLength, seperatorLength, startLength)
		)
		-- Wrapped comment.
		table.insert(
			insert_lines,
			generate_centered_comment(comment, bufLineLength, length, language_config, endLength, startLength)
		)
		-- End solid line.
		table.insert(
			insert_lines,
			generate_solid_line(length, language_config, endLength, seperatorLength, startLength)
		)

		-- Get current buffer row number.
		currentRow = vim.api.nvim_win_get_cursor(0)[1]
		-- Insert lines.
		vim.api.nvim_buf_set_lines(0, currentRow - 1, currentRow, false, insert_lines)
	end)
end

return generator
