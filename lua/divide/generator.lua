local generator = {}

-- subheader example:
-- ------------------------------- subheader -------------------------------- --

generator.subheader = function(config)
	local width = config.width
	local char = config.char
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	local language_config = config.languages[filetype]
	language_config = language_config or config.default
	local line_start = language_config.line_start
	local line_end = language_config.line_end

	local current_row = vim.api.nvim_win_get_cursor(0)[1]
	local comment = vim.api.nvim_get_current_line()
	if comment == "" then
		vim.api.nvim_err_writeln("No comment found for subheader generation.")
		return
	end
	comment = " " .. comment:match("^%s*(.-)%s*$") .. " " -- trim with one space on each side
	local total_separator_length = width - #comment - #line_start - #line_end - 2
	local left_separator = string.rep(char, math.floor(total_separator_length / 2))
	local right_separator = string.rep(char, math.ceil(total_separator_length / 2))

	local subheader = line_start .. " " .. left_separator .. comment .. right_separator .. " " .. line_end

	vim.api.nvim_buf_set_lines(0, current_row - 1, current_row, false, { subheader })
end

-- header example:
-- -------------------------------------------------------------------------- --
--                                   header                                   --
-- -------------------------------------------------------------------------- --

generator.header = function(config)
	local width = config.width
	local char = config.char
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	local language_config = config.languages[filetype]
	language_config = language_config or config.default
	local line_start = language_config.line_start
	local line_end = language_config.line_end

	local current_row = vim.api.nvim_win_get_cursor(0)[1]
	local comment = vim.api.nvim_get_current_line()
	if comment == "" then
		vim.api.nvim_err_writeln("No comment found for header generation.")
		return
	end
	comment = comment:match("^%s*(.-)%s*$") -- trim white spaces
	local total_padding_length = width - #comment - #line_start - #line_end
	local left_padding = string.rep(" ", math.floor(total_padding_length / 2))
	local right_padding = string.rep(" ", math.ceil(total_padding_length / 2))
	comment = line_start .. left_padding .. comment .. right_padding .. line_end

	local separator_length = width - #line_start - #line_end - 2
	local separator = string.rep(char, separator_length)
	local separator_comment = line_start .. " " .. separator .. " " .. line_end

	local header = {
		separator_comment,
		comment,
		separator_comment,
	}

	vim.api.nvim_buf_set_lines(0, current_row - 1, current_row, false, header)
end

-- divider example:
-- -------------------------------------------------------------------------- --

generator.divider = function(config)
	local width = config.width
	local char = config.char
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	local language_config = config.languages[filetype]
	language_config = language_config or config.default
	local line_start = language_config.line_start
	local line_end = language_config.line_end

	local current_row = vim.api.nvim_win_get_cursor(0)[1]
	local separator_length = width - #line_start - #line_end - 2
	local separator = string.rep(char, separator_length)

	local divider = line_start .. " " .. separator .. " " .. line_end

	vim.api.nvim_buf_set_lines(0, current_row - 1, current_row, false, { divider })
end

return generator
