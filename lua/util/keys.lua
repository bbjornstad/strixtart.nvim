local M = {}

function M.by_mode(mode, glopts)
  return function(lhs, rhs, opts)
    opts = vim.tbl_deep_extend("force", {
      buffer = glopts.buffer,
    }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

return M
