local nightowl_splash_frames = require("env.alpha").neostrix_splash_frames

local fz = require("util.fz")

---@param animation_speed number
local function header_animated(animation_speed, frames)
  local timer = vim.uv.new_timer()
  ---@type string[]
  local current_frame = {}
  local i = 0
  timer:start(
    0,
    1000 * animation_speed,
    vim.schedule_wrap(function()
      if vim.bo.filetype ~= "starter" then
        timer:stop()
        return
      end
      i = math.fmod(i, #frames)
      if i == nil then
        i = 0
      end
      i = i + 1
      current_frame = frames[i]
      require("mini.starter").refresh()
    end)
  )

  return function()
    local frame = table.concat(current_frame, "\n")
    return frame
  end
end

local function timer_footer()
  local timer = vim.uv.new_timer()
  local time_in_dashboard = 0
  timer:start(
    0,
    1000 * 60,
    vim.schedule_wrap(function()
      if vim.bo.filetype ~= "starter" then
        timer:stop()
        return
      end
      time_in_dashboard = time_in_dashboard + 1
      require("mini.starter").refresh()
    end)
  )
  return function()
    local hours, minutes = math.modf(time_in_dashboard / 60)
    minutes = minutes * 60
    return string.format(
      "~ %s time spent with option paralysis: %d:%02d %s ~",
      string.rep(" ", 4),
      hours,
      minutes,
      string.rep(" ", 4)
    )
  end
end

return {
  {
    "echasnovski/mini.starter",
    version = false,
    event = "UIEnter",
    opts = {
      autoopen = true,
      evaluate_single = true,
      header = header_animated(2.4, nightowl_splash_frames),
      footer = timer_footer(),
      silent = false,
      query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_-.",
      items = {
        {
          name = "cwd",
          action = function()
            local path = vim.fs.normalize(vim.fn.getcwd())
            vim.cmd.tcd(path)
            vim.cmd.edit(".")
          end,
          section = "marks:|entree",
        },
        {
          name = "lab",
          action = function()
            local path = vim.fs.normalize(vim.fs.joinpath("$HOME", "lab"))
            vim.cmd.tcd(path)
            vim.cmd.edit(".")
          end,
          section = "marks:|entree",
        },
        {
          name = "org",
          action = function()
            local path = vim.fs.normalize(vim.fs.joinpath("$HOME", "org"))
            vim.cmd.tcd(path)
            vim.cmd.edit(".")
          end,
          section = "marks:|entree",
        },
        {
          name = "neovim",
          action = function()
            local path =
              vim.fs.normalize(vim.fs.joinpath("$XDG_CONFIG_HOME", "nvim"))
            vim.cmd.tcd(path)
            vim.cmd.edit(".")
          end,
          section = "marks:|confit",
        },
        {
          name = "nushell",
          action = function()
            local path =
              vim.fs.normalize(vim.fs.joinpath("$XDG_CONFIG_HOME", "nushell"))
            vim.cmd.tcd(path)
            vim.cmd.edit(".")
          end,
          section = "marks:|confit",
        },
        {
          name = "subdirectory",
          action = function()
            local path = vim.fs.normalize(vim.fn.getcwd())
            fz.fzd({ cwd = path })
          end,
          section = "search:|entree",
        },
        {
          name = "cwd",
          action = fz.fza("files", { cwd = vim.fs.normalize(vim.fn.getcwd()) }),
          section = "search:|entree",
        },
        {
          name = "lab",
          action = fz.fza(
            "files",
            { cwd = vim.fs.normalize(vim.fs.joinpath("$HOME", "lab")) }
          ),
          section = "search:|entree",
        },
        {
          name = "org",
          action = fz.fza(
            "files",
            { cwd = vim.fs.normalize(vim.fs.joinpath("$HOME", "org")) }
          ),
          section = "search:|entree",
        },
        {
          name = "neovim",
          action = fz.fza(
            "files",
            { cwd = vim.fs.normalize(vim.fn.stdpath("config")) }
          ),
          section = "search:|confit",
        },
        {
          name = "nushell",
          action = fz.fza("files", {
            cwd = vim.fs.normalize(
              vim.fs.joinpath("$XDG_CONFIG_HOME", "nushell")
            ),
          }),
          section = "search:|confit",
        },
        { "recent_files", { 5, true } },
        { "builtin_actions" },
      },
      content_hooks = {
        { "adding_bullet" },
        {
          "indexing",
          {
            "section",
            {
              "Builtin actions",
              "marks:|confit",
              "marks:|entree",
            },
          },
        },
        { "aligning", { "center", "center" } },
      },
    },
    keys = {
      {
        "<Home>",
        function()
          require("mini.starter").open()
        end,
        mode = "n",
        desc = "א:| home |=> open",
      },
    },
  },
  {
    "echasnovski/mini.starter",
    config = function(_, opts)
      local MiniStarter = require("mini.starter")
      opts = opts or {}
      opts.items = opts.items or {}
      for i, v in ipairs(opts.items) do
        local sect_key, args = unpack(v)
        if sect_key ~= nil then
          opts.items[i] = MiniStarter.sections[sect_key](unpack(args or {}))
        end
      end
      for i, v in ipairs(opts.content_hooks) do
        local sect_key, args = unpack(v)
        if sect_key ~= nil then
          opts.content_hooks[i] =
            MiniStarter.gen_hook[sect_key](unpack(args or {}))
        end
      end
      MiniStarter.setup(opts)
    end,
  },
}
