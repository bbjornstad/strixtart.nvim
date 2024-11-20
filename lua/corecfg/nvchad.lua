local M = {}

function M.setup_cache(path)
  vim.g.base46_cache = path
end

function M.prepare()
  dofile(vim.fs.joinpath(vim.g.base46_cache, "defaults"))
  dofile(vim.fs.joinpath(vim.g.base46_cache, "statusline"))
end

return M
