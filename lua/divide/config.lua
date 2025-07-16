local default_config = {
	width = 80,
	char = "-",
	default = {
		line_start = "/*",
		line_end = "*/",
	},
	languages = {
		python = {
			line_start = "#",
			line_end = "#",
		},
		lua = {
			line_start = "--",
			line_end = "--",
		},
	},
}

return default_config
