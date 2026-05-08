-- Beginner-friendly defaults layered on top of LazyVim.
vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false

-- LazyVim TypeScript extra supports vtsls or tsgo. vtsls is stable/default.
vim.g.lazyvim_ts_lsp = 'vtsls'
