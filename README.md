# divide.nvim

Neovim replacement for the [Comment Divider](https://github.com/stackbreak/comment-divider) VS Code extension.

Originally forked from [fangjunzhou/comment-divider.nvim](https://github.com/fangjunzhou/comment-divider.nvim), but heavily reworked.

## Install

### lazy.nvim
```lua
{
	'brendon-felix/divide.nvim',
	event = 'VeryLazy',
	opts = {},
}
```

## Configuration

### Default

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

### Example Config using lazy.nvim

```lua
{
  'brendon-felix/divide.nvim',
  event = 'VeryLazy',
  keys = {
	  {
		  '<leader>ds',
		  function()
			  require('divide').subheader()
		  end,
		  desc = '[D]ivide with [S]ubheader',
	  },
	  {
		  '<leader>dh',
		  function()
			  require('divide').header()
		  end,
		  desc = '[D]ivide with [H]eader',
	  },
	  {
		  '<leader>dd',
		  function()
			  require('divide').divider()
		  end,
		  desc = '[D]ivide with [D]ivider',
	  },
  },
  config = function()
	  require('divide').setup {
		  language_config = {
			  nu = {
				  line_start = '#',
				  line_end = '#',
				  character = '-',
			  },
		  },
	  }
  end,
}
```

## Usage

### Subheader

```lua
require('divide').subheader()
```

```
/* ------------------------------- Subheader -------------------------------- */
```

### Header

```lua
require('divide').header()
```

```
/* -------------------------------------------------------------------------- */
/*                                   Header                                   */
/* -------------------------------------------------------------------------- */
```

### Divider

```lua
require('divide').divider()
```

```
/* -------------------------------------------------------------------------- */
```

## TODO
- [ ] Fix/update user commands
- [ ] Auto indent (`indent = { enable = true}`)
- [ ] Shorten with indent (`indent = { enable = true, shorten = true}`)
- [ ] Multi-character line pattern (change `char` to `pattern`)
- [ ] Change text alignment (`left`, `right`, `center (default)`)
- [ ] Multi-line header

