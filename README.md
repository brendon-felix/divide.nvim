# divide.nvim

Neovim replacement for the [Comment Divider](https://github.com/stackbreak/comment-divider) VS Code extension.

Originally forked from [fangjunzhou/comment-divider.nvim](https://github.com/fangjunzhou/comment-divider.nvim), but heavily reworked.

## Install

### lazy
```lua
{
	'brendon-felix/divide.nvim',
	event = 'VeryLazy',
	opts = {},
}
```

## Configuration

```lua
-- default config
{
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
```
