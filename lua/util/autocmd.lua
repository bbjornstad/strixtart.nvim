---@class util.autocmd
local M = {}

--- builder that provides a function to create autocommands for a particular
--- specified group.
---@param group_name string name of an autocommand group to create or add to.
---@param clear boolean? whether or not the autocommand group should be cleared
---before adding; defaults to `true`.
---@return fun(events: string | string[], opts: vim.api.keyset.create_autocmd)
function M.autocmdr(group_name, clear)
  clear = clear ~= nil and clear or true
  local augroup = vim.api.nvim_create_augroup(group_name, { clear = clear })

  return function(events, opts)
    opts = vim.tbl_deep_extend("force", { group = augroup }, opts)
    vim.schedule(function()
      vim.api.nvim_create_autocmd(events, opts)
    end)
  end
end

function M.ftcmdr(group_name, clear)
  local cmdr = M.autocmdr(group_name, clear)
  return function(ftypes, opts)
    cmdr(
      { "FileType" },
      vim.tbl_deep_extend("force", { pattern = ftypes }, opts)
    )
  end
end

function M.buffixcmdr(group_name, clear)
  local cmdr = M.autocmdr(group_name, clear)
  return function(events, opts)
    cmdr(
      events,
      vim.tbl_deep_extend("force", {
        callback = function(ev)
          local winnr = vim.api.nvim_get_current_win()
          if ev.buf ~= vim.api.nvim_win_get_buf(winnr) then
            return
          end
          if vim.fn.exists("&winfixbuf") == 1 then
            vim.api.nvim_set_option_value("winfixbuf", true, { win = winnr })
          end
        end,
      }, opts)
    )
  end
end

return M
