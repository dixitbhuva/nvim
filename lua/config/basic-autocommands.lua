----- Highlight when yanking (copying) text -----
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

----- set specific indentation for different file types -----
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "java", "c", "cpp", "php", "yaml", "json", "lua", "sh" }, -- 4 spaces languages
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "html", "css", "bash", "toml", "xml", "ini" }, -- 2 spaces languages
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})
