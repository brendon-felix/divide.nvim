local default_config = {
	-- debug = true,
	length = 80,
	default = {
		line_start = "/*",
		line_end = "*/",
		character = "-",
	},
	language_config = {
		cpp = {
			line_start = "/*",
			line_end = "*/",
			character = "-",
		},
		python = {
			line_start = "#",
			line_end = "#",
			character = "-",
		},
		lua = {
			line_start = "--",
			line_end = "--",
			character = "-",
		},
	},
}

return default_config
