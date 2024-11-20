local M = {}

function M.bindfz(fz, opts, target)
  opts = opts or {}
  target = target or "search"
  opts = vim.is_callable(opts) and opts(target) or opts

  return function()
    fz(vim.tbl_deep_extend("force", {
      winopts = { title = (" 󱈇 fz:%s "):format(target) },
    }, opts))
  end
end

function M.fz_direct(target, opts, ...)
  local f = require("fzf-lua")[target]
  opts = vim.tbl_deep_extend("force", {
    title = (" 󱈇 fz:%s "):format(target),
  })
  return f(..., opts)
end

--- function factory to create a bindable action for keymapping shortcuts to fzf
---@param target string | fun(): string | fun(): any[] name of an
---fzf-implemented function that should be called. This should be a member of
---the `fzf-lua` package, e.g. accessible at `require("fzf-lua")[target]`.
---@param opts funsak.GenericOpts? optional configuration overrides for the
---particular called function
---@return fun() bindable a function which can be used directly as the action in
---a lazy.nvim keybinding.
function M.fza(target, opts)
  opts = opts or {}
  opts = vim.is_callable(opts) and opts(target) or opts
  return function()
    require("fzf-lua")[target](vim.tbl_deep_extend("force", {
      winopts = { title = (" 󱈇 fz:%s "):format(target) },
    }, opts))
  end
end

M.load = {}

function M.load.directories(opts)
  opts = opts or {}
  local fzf_lua = require("fzf-lua")
  opts.title = " 󱈇 fz:dir "
  opts.prompt = vim.uv.cwd() .. ": "
  opts.fn_transform = function(x)
    return fzf_lua.utils.ansi_codes.magenta(x)
  end
  opts.actions = {
    ["default"] = function(selected)
      vim.cmd("cd " .. vim.fs.normalize(selected[1]))
    end,
  }
  fzf_lua.fzf_exec("fd --type d --hidden", opts)
end

--- creates an fzf-window for browsing directories. Provides options for the
--- scope of the change of directory (tab, buffer, or global)
---@param opts table fzf-lua options
M.fzd = function(opts)
  return M.bindfz(M.load.directories, opts, "dir")
end

function M.fzvs(target, opts)
  return M.fza(
    target,
    vim.is_callable(opts) and opts(target)
      or vim.tbl_deep_extend("force", opts, {
        cmd = string.format(
          [[--color=never --type f --hidden --follow --exclude .git -x printf "{}: {/} %s\n"]],
          require("fzf-lua.utils").ansi_codes.grey("{//}")
        ),
        fzf_opts = vim.tbl_deep_extend("force", opts.fzf_opts or {}, {
          ["--with-nth"] = "2..",
          ["--tiebreak"] = "begin,index",
        }),
      })
  )
end

return M
