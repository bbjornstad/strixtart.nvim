local env = require("env.ui")
local ftenv = require("env.filesystem")

local key_git = require("keys.git")
local key_session = require("keys.session")
local key_view = require("keys.view")
local key_visits = require("keys.history").visits

local function session_files(file)
  local lines = {}
  local cwd, cwd_pat = "", "^cd%s*"
  local buf_pat = "^badd%s*%+%d+%s*"
  for line in io.lines(file) do
    if string.find(line, cwd_pat) then
      cwd = line:gsub("%p", "%%%1")
    end
    if string.find(line, buf_pat) then
      lines[#lines + 1] = line
    end
  end
  local buffers = {}
  for k, v in pairs(lines) do
    buffers[k] =
      v:gsub(buf_pat, ""):gsub(cwd:gsub("cd%s*", ""), ""):gsub("^/?%.?/", "")
  end
  return buffers
end

local function branch_action(action, ...)
  local args = { ... }
  local function act()
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
    if vim.v.shell_error ~= 0 then
      return nil
    end
    branch = vim.trim(branch)
    require("mini.visits")[action](branch, unpack(args or {}))
  end
  return act
end

return {
  {
    "kevinhwang91/nvim-fundo",
    opts = {
      archives_dir = vim.fn.stdpath("cache") .. "/fundo",
      limit_archives_size = 256,
    },
    init = function()
      vim.o.undofile = true
    end,
    build = function(_)
      require("fundo").install()
    end,
    event = { "VeryLazy" },
  },
  {
    "jiaoshijie/undotree",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        key_view.undotree.toggle,
        function()
          require("undotree").toggle()
        end,
        mode = "n",
        desc = "undo:| tree |=> toggle",
        noremap = true,
        silent = true,
      },
      {
        key_view.undotree.open,
        function()
          require("undotree").open()
        end,
        mode = "n",
        desc = "undo:| tree |=> open",
        noremap = true,
        silent = true,
      },
      {
        key_view.undotree.close,
        function()
          require("undotree").close()
        end,
        mode = "n",
        desc = "undo:| tree |=> close",
        noremap = true,
        silent = true,
      },
    },
    opts = {
      float_diff = false, -- using float window previews diff, set this `true` will disable layout option
      layout = "left_left_bottom", -- "left_bottom", "left_left_bottom"
      ignore_filetype = ftenv.ft_ignore_list,
      window = { winblend = 20 },
      keymaps = {
        ["j"] = "move_next",
        ["k"] = "move_prev",
        ["J"] = "move_change_next",
        ["K"] = "move_change_prev",
        ["<cr>"] = "action_enter",
        ["p"] = "enter_diffbuf",
        ["q"] = "quit",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      {
        key_git.diffview,
        "<CMD>DiffviewOpen<CR>",
        mode = "n",
        desc = "git:| diff |=> compare",
      },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Neogit" },
    opts = {
      disable_commit_confirmation = true,
      disable_insert_on_commit = "auto",
      signs = {
        section = { "󰧛", "󰧗" },
        item = { "󰄾", "󰄼" },
        hunk = { "", "" },
      },
      integrations = { fzf_lua = true, diffview = true },
      graph_style = "unicode",
      git_services = {
        ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
        ["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
        ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
      },
    },
    keys = {
      {
        key_git.neogit,
        "<CMD>Neogit<CR>",
        mode = { "n" },
        desc = "git:| neo |=> open",
      },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    cmd = {
      "GitConflictChooseOurs",
      "GitConflictChooseTheirs",
      "GitConflictChooseBoth",
      "GitConflictChooseNone",
      "GitConflictNextConflict",
      "GitConflictPrevConflict",
      "GitConflictListQf",
    },
    keys = {
      {
        key_git.conflict.quickfix,
        "<CMD>GitConflictListQf<CR>",
        mode = "n",
        desc = "git:| conflict |=> quick fix",
      },
      {
        key_git.conflict.choose_ours,
        "<CMD>GitConflictChooseOurs<CR>",
        mode = "n",
        desc = "git:| conflict |=> ours",
      },
      {
        key_git.conflict.choose_theirs,
        "<CMD>GitConflictChooseTheirs<CR>",
        mode = "n",
        desc = "git:| conflict |=> theirs",
      },
      {
        key_git.conflict.choose_both,
        "<CMD>GitConflictChooseBoth<CR>",
        mode = "n",
        desc = "git:| conflict |=> both",
      },
      {
        key_git.conflict.choose_none,
        "<CMD>GitConflictChooseNone<CR>",
        mode = "n",
        desc = "git:| conflict |=> none",
      },
      {
        key_git.conflict.next,
        "<CMD>GitConflictNextConflict<CR>",
        mode = "n",
        desc = "git:| conflict |=> next",
      },
      {
        key_git.conflict.previous,
        "<CMD>GitConflictPrevConflict<CR>",
        mode = "n",
        desc = "git:| conflict |=> previous",
      },
    },
  },
  {
    "topaxi/gh-actions.nvim",
    cmd = "GhActions",
    keys = {
      {
        key_git.gh_actions,
        "<cmd>GhActions<cr>",
        mode = "n",
        desc = "::git=> Github Actions",
      },
    },
    -- optional, you can also install and use `yq` instead.
    build = "make",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  },
  {
    "niuiic/git-log.nvim",
    opts = {
      extra_args = {},
      win = {
        border = env.borders.main,
        width_ratio = 0.6,
        height_ratio = 0.6,
      },
      keymap = { close = "q" },
    },
    keys = {
      {
        key_git.log,
        function()
          require("git-log").check_log()
        end,
        mode = { "n" },
        -- mode = { "n", "v" },
        desc = "git:| log |=> check",
      },
    },
  },
  {
    "FredeEB/tardis.nvim",
    cmd = "Tardis",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keymap = {
        next = "<C-n>",
        prev = "<C-p>",
        quit = "<C-c>",
        commit_message = "m",
      },
    },
    config = function(_, opts)
      require("tardis-nvim").setup(opts)
    end,
    keys = {
      {
        key_git.tardis,
        "<CMD>Tardis<CR>",
        mode = "n",
        desc = "git:| tardis |=> open",
      },
    },
  },
  {
    "gennaro-tedesco/nvim-possession",
    dependencies = { "ibhagwan/fzf-lua" },
    opts = {
      autoswitch = { enable = true },
      sessions = {
        sessions_path = vim.fs.joinpath(vim.fn.stdpath("data"), "sessions"),
        sessions_icon = "󰨇",
        sessions_prompt = "󱈇 fz:sessions",
      },
      fzf_winopts = {
        width = 0.64,
        preview = {
          vertical = "right:50%",
        },
      },
    },
    keys = {
      {
        key_session.list,
        function()
          require("nvim-possession").list()
        end,
        mode = "n",
        desc = "session:| sesh |=> list",
      },
      {
        key_session.new,
        function()
          require("nvim-possession").new()
        end,
        mode = "n",
        desc = "session:| sesh |=> new",
      },
      {
        key_session.update,
        function()
          require("nvim-possession").update()
        end,
        mode = "n",
        desc = "session:| sesh |=> update",
      },
      {
        key_session.delete,
        function()
          require("nvim-possession").delete()
        end,
        mode = "n",
        desc = "session:| sesh |=> delete",
      },
    },
  },
  {
    "willothy/savior.nvim",
    dependencies = { "j-hui/fidget.nvim" },
    event = { "InsertEnter", "TextChanged" },
    opts = {
      events = {
        immediate = { "FocusLost", "BufLeave" },
        deferred = { "InsertLeave", "TextChanged" },
        cancel = { "InsertEnter", "BufWritePost", "TextChanged" },
      },
      callbacks = {},
      throttle_ms = 3000,
      interval_ms = 30000,
      defer_ms = 1000,
    },
  },
  {
    "echasnovski/mini.visits",
    opts = {},
    keys = {
      {
        key_visits.label.add,
        function()
          require("mini.visits").add_label()
        end,
        mode = "n",
        desc = "hist:| label |=> add",
      },
      {
        key_visits.label.remove,
        function()
          require("mini.visits").remove_label()
        end,
        mode = "n",
        desc = "hist:| label |=> remove",
      },
      {
        key_visits.label.select,
        function()
          require("mini.visits").select_label()
        end,
        mode = "n",
        desc = "hist:| label |=> select",
      },
      {
        key_visits.label.list,
        function()
          require("mini.visits").list_labels()
        end,
        mode = "n",
        desc = "hist:| label |=> list",
      },
      {
        key_visits.branch.add,
        branch_action("add_label"),
        mode = "n",
        desc = "hist:| branch |=> add",
      },
      {
        key_visits.branch.remove,
        branch_action("remove_label"),
        mode = "n",
        desc = "hist:| branch |=> remove",
      },
      {
        key_visits.path.add,
        function()
          require("mini.visits").add_path()
        end,
        mode = "n",
        desc = "hist:| path |=> add",
      },
      {
        key_visits.path.remove,
        function()
          require("mini.visits").remove_path()
          require("mini.visits").write_index()
        end,
        mode = "n",
        desc = "hist:| path |=> remove",
      },
      {
        key_visits.path.select,
        function()
          require("mini.visits").select_path()
        end,
        mode = "n",
        desc = "hist:| path |=> select",
      },
      {
        key_visits.path.list,
        function()
          require("mini.visits").list_paths()
        end,
        mode = "n",
        desc = "hist:| path |=> list",
      },
      {
        key_visits.register,
        function()
          require("mini.visits").register_visit()
        end,
        mode = "n",
        desc = "hist:| path |=> register",
      },
    },
    event = "VeryLazy",
  },
  {
    "natecraddock/workspaces.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function(_, opts)
      require("workspaces").setup(opts)
      require("telescope").load_extension("workspaces")
    end,
    opts = {
      path = vim.fs.joinpath(vim.fn.stdpath("data"), "workspaces"),
      cd_type = "tab",
      auto_open = true,
    },
    event = "VeryLazy",
    cmd = {
      "WorkspacesAdd",
      "WorkspacesAddDir",
      "WorkspacesOpen",
      "WorkspacesRemove",
      "WorkspacesRemoveDir",
      "WorkspacesRename",
      "WorkspacesList",
      "WorkspacesListDirs",
      "WorkspacesSyncDirs",
    },
    keys = {
      {
        key_session.workspaces.add,
        function()
          local thisfile = vim.fn.expand("%", false, false)
          ---@cast thisfile string
          local path = vim.fs.normalize(vim.fn.getcwd(0, 0))
            or vim.fs.dirname(thisfile)
          vim.ui.input({
            prompt = "new workspace name: ",
          }, function(selname)
            vim.ui.select(
              vim
                .iter(vim.fs.dir(path or vim.fn.getcwd(0, 0)))
                :filter(function(item)
                  return item.type == "directory"
                end)
                :totable(),
              {
                prompt = "new workspace path: ",
                format_item = function(item)
                  return item.name
                end,
              },
              function(selpath, idx)
                require("workspaces").add(selpath, selname)
              end
            )
          end)
        end,
        mode = "n",
        desc = "session:| spaces |=> new",
      },
      {
        key_session.workspaces.add_dir,
        function()
          local thisfile = vim.fn.expand("%", false, false)
          ---@cast thisfile string
          local path = vim.fs.normalize(vim.fn.getcwd(0, 0))
            or vim.fs.dirname(thisfile)
          vim.ui.select(
            vim
              .iter(vim.fs.dir(path or vim.fn.getcwd(0, 0)))
              :filter(function(item)
                return item.type == "directory"
              end)
              :totable(),
            {
              prompt = "select space supremum: ",
              format_item = function(item)
                return item.name
              end,
            },
            function(sel)
              require("workspaces").add_dir(sel)
            end
          )
        end,
        mode = "n",
        desc = "session:| spaces |=> add supremum",
      },
      {
        key_session.workspaces.remove,
        function()
          vim.ui.select(require("workspaces").get(), {
            prompt = "remove workspace: ",
            format_item = function(item)
              return ("%s: %s -- %s"):format(
                item.name,
                item.path,
                item.last_opened
              )
            end,
          }, function(sel, idx)
            require("workspaces").remove(sel.name)
          end)
        end,
        mode = "n",
        desc = "session:| spaces |=> remove",
      },
      {
        key_session.workspaces.rename,
        function()
          vim.ui.select(require("workspaces").get(), {
            prompt = "old workspace: ",
            format_item = function(item)
              return ("%s: %s -- %s"):format(
                item.name,
                item.path,
                item.last_opened
              )
            end,
          }, function(old, idx)
            vim.ui.input({ prompt = "new workspace name: " }, function(new)
              require("workspaces").rename(old.name, new)
            end)
          end)
        end,
        mode = "n",
        desc = "session:| spaces |=> rename",
      },
      {
        key_session.workspaces.remove_dir,
        function()
          vim.ui.select(require("workspaces").get(), {
            prompt = "remove space supremum: ",
            format_item = function(item)
              return ("%s: %s -- %s"):format(
                item.name,
                item.path,
                item.last_opened
              )
            end,
          }, function(sel, idx)
            require("workspaces").remove_dir(sel.path)
          end)
        end,
        mode = "n",
        desc = "session:| spaces |=> remove supremum",
      },
      {
        key_session.workspaces.list,
        function()
          require("workspaces").list()
        end,
        mode = "n",
        desc = "session:| spaces |=> list",
      },
      {
        key_session.workspaces.list_dirs,
        function()
          require("workspaces").list_dirs()
        end,
        mode = "n",
        desc = "session:| spaces |=> directories",
      },
      {
        key_session.workspaces.sync_dirs,
        function()
          require("workspaces").sync()
        end,
        mode = "n",
        desc = "session:| spaces |=> sync",
      },
      {
        key_session.workspaces.telescope,
        function()
          require("telescope").extensions.workspaces.workspaces()
        end,
        mode = "n",
        desc = "session:| spaces |=> scope",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
      signcolumn = true,
      numhl = true,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "overlay",
        delay = 5000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = "   <author>: [<author_time:%Y-%m-%d %H:%M>] 󱛠 <summary>",
      sign_priority = 5,
      update_debounce = 200,
      status_formatter = nil,
      max_file_length = 100000,
      preview_config = {
        border = env.borders.main,
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    },
    keys = {
      {
        key_git.gitsigns.toggle.numhl,
        function()
          require("gitsigns").toggle_numhl()
        end,
        mode = "n",
        desc = "git:tgl| signs |=> numhl",
      },
      {
        key_git.gitsigns.toggle.linehl,
        function()
          require("gitsigns").toggle_linehl()
        end,
        mode = "n",
        desc = "git:tgl| signs |=> linehl",
      },
      {
        key_git.gitsigns.toggle.signs,
        function()
          require("gitsigns").toggle_signs()
        end,
        mode = "n",
        desc = "git:tgl| signs |=> signs",
      },
      {
        key_git.gitsigns.toggle.word_diff,
        function()
          require("gitsigns").toggle_word_diff()
        end,
        mode = "n",
        desc = "git:tgl| signs |=> word diff",
      },
      {
        key_git.gitsigns.toggle.line_blame,
        function()
          require("gitsigns").toggle_current_line_blame()
        end,
        mode = "n",
        desc = "git:tgl| signs |=> line blame",
      },
      {
        key_git.gitsigns.toggle.deleted,
        function()
          require("gitsigns").toggle_deleted()
        end,
        mode = "n",
        desc = "git:tgl| signs |=> deleted",
      },
      {
        key_git.gitsigns.preview.hunk,
        function()
          require("gitsigns").preview_hunk()
        end,
        mode = "n",
        desc = "git:view| signs |=> hunk",
      },
      {
        key_git.gitsigns.preview.hunk_inline,
        function()
          require("gitsigns").preview_hunk_inline()
        end,
        mode = "n",
        desc = "git:view| signs |=> inline hunk",
      },
      {
        key_git.gitsigns.refresh,
        function()
          require("gitsigns").refresh()
        end,
        mode = "n",
        desc = "git:view| signs |=> inline hunk",
      },
      {
        key_git.gitsigns.diffthis,
        function()
          require("gitsigns").diffthis()
        end,
        mode = "n",
        desc = "git:diff| signs |=> diffthis",
      },
    },
  },
  {
    "SuperBo/fugit2.nvim",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      {
        "chrisgrieser/nvim-tinygit",
        dependencies = { "stevearc/dressing.nvim" },
      },
      "sindrets/diffview.nvim",
    },
    cmd = { "Fugit2", "Fugit2Graph", "Fugit2Diff" },
    keys = {
      {
        key_git.fugit.open,
        "<CMD>Fugit2<CR>",
        mode = "n",
        desc = "git:| fu => open",
      },
      {
        key_git.fugit.graph,
        "<CMD>Fugit2Graph<CR>",
        mode = "n",
        desc = "git:| fu => graph",
      },
      {
        key_git.fugit.diff,
        "<CMD>Fugit2Diff<CR>",
        mode = "n",
        desc = "git:| fu => diff",
      },
    },
  },
  {
    "kilavila/nvim-gitignore",
    cmd = { "Gitignore", "Licenses" },
    opts = {},
    config = function(_, opts) end,
    keys = {
      {
        key_git.ignore.generate,
        "<CMD>Gitignore<CR> ",
        mode = "n",
        desc = "git:| ignore |=> generate",
      },
      {
        key_git.ignore.licenses,
        "<CMD>Licenses<CR> ",
        mode = "n",
        desc = "git:| license |=> select",
      },
    },
  },
  {
    "3rd/time-tracker.nvim",
    enabled = false,
    dependencies = {
      "3rd/sqlite.nvim",
    },
    event = "VeryLazy",
    opts = {
      data_file = vim.fn.stdpath("data") .. "/time-tracker.db",
      tracking_events = {
        "BufEnter",
        "BufWinEnter",
        "CursorMoved",
        "CursorMovedI",
        "WinScrolled",
      },
      tracking_timeout_seconds = 5 * 60, -- 5 minutes
    },
  },
  {
    "julienvincent/hunk.nvim",
    cmd = { "DiffEditor" },
    opts = {
      keys = {
        global = {
          quit = { "q" },
          accept = { "<leader><Cr>" },
          focus_tree = { "<leader>e" },
        },

        tree = {
          expand_node = { "l", "<Right>" },
          collapse_node = { "h", "<Left>" },

          open_file = { "<Cr>" },

          toggle_file = { "a" },
        },

        diff = {
          toggle_line = { "a" },
          toggle_hunk = { "A" },
        },
      },

      ui = {
        tree = {
          -- Mode can either be `nested` or `flat`
          mode = "nested",
          width = 35,
        },
        --- Can be either `vertical` or `horizontal`
        layout = "vertical",
      },

      icons = {
        selected = "󰡖",
        deselected = "",
        partially_selected = "󰛲",

        folder_open = "",
        folder_closed = "",
      },

      -- Called right after each window and buffer are created.
      hooks = {
        ---@param _context { buf: number, tree: NuiTree, opts: table }
        on_tree_mount = function(_context) end,
        ---@param _context { buf: number, win: number }
        on_diff_mount = function(_context) end,
      },
    },
  },
}
