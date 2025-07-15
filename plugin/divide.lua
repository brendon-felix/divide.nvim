-- Comment divider line.
vim.api.nvim_create_user_command("CommentDividerLine", function()
	require("divide").subheader()
end, { nargs = 0 })

-- Comment divider box.
vim.api.nvim_create_user_command("CommentDividerBox", function()
	require("divide").header()
end, { nargs = 0 })

-- Show current config.
vim.api.nvim_create_user_command("CommentDividerConfigInfo", function()
	require("divide").info()
end, { nargs = 0 })

-- Check current filetype.
vim.api.nvim_create_user_command("CommentDividerFiletype", function()
	require("divide").filetype()
end, { nargs = 0 })
