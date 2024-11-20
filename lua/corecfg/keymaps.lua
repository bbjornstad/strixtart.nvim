local quill = require("util.quill")
local toggle = require("util.toggle")

local mapx = vim.keymap.set

local key_buffers = require("keys.buffer")
local key_lazy = require("keys.lazy")
local key_lists = require("keys.lists")
local key_ui = require("keys.ui")

-- ─[ general improvements ]───────────────────────────────────────────────

-- gets the help in vim documentation for the item under the cursor
local function helpmapper()
  local thishelp = ("help %s"):format(vim.fn.expand("<cword>"))
  vim.cmd(thishelp)
end

-- for better default experience
-- mapx({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- better up/down, handling word wrap scenarios gracefully.
mapx(
  { "n", "x" },
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
mapx(
  { "n", "x" },
  "<Down>",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
mapx(
  { "n", "x" },
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)
mapx(
  { "n", "x" },
  "<Up>",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)

-- Rebind the help menu to be attached to "gh"
mapx(
  "n",
  "<leader>hh",
  helpmapper,
  { desc = "help:| get |", remap = false, nowait = true }
)

-- because I spam escape in the upper left corner sometimes, the following binds
-- stop help from showing up on any touch of the <f1> key by default, which gets
-- annoying as heck.
mapx(
  { "n", "i" },
  "<F1>",
  "<NOP>",
  { desc = "help:| nop |", remap = true, nowait = false }
)

-- ─[ motion keymappings: ]────────────────────────────────────────────────
-- Move Lines
mapx("n", "<A-S-j>", "<cmd>m .+1<cr>==", { desc = "line:| move |=> down" })
mapx("n", "<A-S-k>", "<cmd>m .-2<cr>==", { desc = "line:| move |=> up" })
mapx(
  "i",
  "<A-S-j>",
  "<esc><cmd>m .+1<cr>==gi",
  { desc = "line:| move |=> down" }
)
mapx("i", "<A-S-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "line:| move |=> up" })
mapx("v", "<A-S-j>", ":m '>+1<cr>gv=gv", { desc = "line:| move |=> down" })
mapx("v", "<A-S-k>", ":m '<-2<cr>gv=gv", { desc = "line:| move |=> up" })

-- move to beginning and end of line with S-H and S-L, overriding the lazyvim
-- default behavior which is next and previous buffers. These are rebound to
-- include Control modifier, so that I stop accidentally switching buffers when
-- I don't want to.
mapx("i", "<C-S-h>", "<C-o>_", { desc = "goto:| |=> line first character" })
mapx("i", "<C-S-l>", "<C-o>$", { desc = "goto:| |=> line end character" })
mapx("i", "<C-j>", "<C-o><down>", { desc = "buf:| |=> cursor down" })
mapx("i", "<C-k>", "<C-o><up>", { desc = "buf:| |=> cursor up" })
mapx("i", "<C-h>", "<C-o><left>", { desc = "buf:| |=> cursor left" })
mapx("i", "<C-l>", "<C-o><right>", { desc = "buf:| |=> cursor right" })
mapx({ "n", "o", "v" }, "H", "^", { desc = "`^` SOL" })
mapx({ "n", "o", "v" }, "L", "$", { desc = "`$` EOL" })

-- ─[ Ctrl-Q Quit Bindings ]───────────────────────────────────────────────
mapx(
  "n",
  "<C-q><C-q>",
  "<CMD>quit<CR>",
  { desc = "quit:buf| terminate |=> nosave" }
)
mapx(
  "n",
  "<C-q><C-w>",
  "<CMD>wq<CR>",
  { desc = "quit:buf| terminate |=> save" }
)
mapx("n", "<C-q>w", "<CMD>wq<CR>", { desc = "quit:buf| terminate |=> save" })
mapx("n", "<C-q>!", "<CMD>quit!<CR>", { desc = "quit:!| terminate => nosave" })
mapx(
  "n",
  "<C-q><C-!>",
  "<CMD>quit!<CR>",
  { desc = "quit:!| terminate => nosave" }
)
mapx(
  "n",
  "<C-S-q>w",
  "<CMD>wqall<CR>",
  { desc = "quit:all| terminate |=> save" }
)
mapx(
  "n",
  "<C-S-q><C-w>",
  "<CMD>wqall<CR>",
  { desc = "quit:all| terminate |=> save" }
)
mapx(
  "n",
  "<C-S-q>Q",
  "<CMD>quitall<CR>",
  { desc = "quit:all| terminate => nosave" }
)
mapx(
  "n",
  "<C-S-q><C-S-q>",
  "<CMD>quitall<CR>",
  { desc = "quit:all| terminate |=> nosave" }
)
mapx(
  "n",
  "<C-S-q><C-!>",
  "<CMD>quitall!<CR>",
  { desc = "quit:all!| terminate |=> nosave" }
)
mapx(
  "n",
  "<C-S-q>!",
  "<CMD>quitall!<CR>",
  { desc = "quit:all!| terminate |=> nosave" }
)

-- remove macro on the q key, as I prefer to use a plugin to handle macros and
-- the q key is prime real estate for other functions.
-- mapx("n", "q", "<NOP>", { desc = "macro:| |=> don't record" })

-- ─[ buffers, saving, files ]─────────────────────────────────────────────
mapx("n", "<leader>fe", function()
  vim.ui.input({ prompt = "󰎝 enter filename: " }, function(input)
    vim.cmd(("edit ./%s"):format(input))
  end)
end, { desc = "buf:| new |" })
mapx("n", key_buffers.write, "<CMD>write<CR>", { desc = "buf:current| save |" })
mapx(
  "n",
  key_buffers.writeall,
  "<CMD>writeall<CR>",
  { desc = "buf:all| save |" }
)
mapx("n", key_buffers.write, "<CMD>write<CR>", { desc = "buf:current| save |" })
mapx(
  "n",
  key_buffers.writeall,
  "<CMD>writeall<CR>",
  { desc = "buf:all| save |" }
)

-- navigating buffers with non-shortcutted keymaps.
-- NOTE: This should be done most effectively in a wrapping conditional check
-- for plugins that may interfere with the typical behavior, even though
-- ultimately they should be overwritten with the plugin regardless.

mapx("n", "<C-S-h>", "<cmd>bprevious<cr>", { desc = "buf:| goto |=> previous" })
mapx("n", "<C-S-l>", "<cmd>bnext<cr>", { desc = "buf:| goto |=> next" })
mapx("n", "[b", "<cmd>bprevious<cr>", { desc = "buf:| goto |=> previous" })
mapx("n", "]b", "<cmd>bnext<cr>", { desc = "buf:| goto |=> next" })
mapx("n", "<leader>bb", "<cmd>e #<cr>", { desc = "buf:| goto |=> alternate" })

-- ─[ Window Keymaps ]─────────────────────────────────────────────────────
-- closing windows without quitting.
mapx("n", "<C-c>", function()
  vim.api.nvim_win_close(0, false)
end, { desc = "win:current| close |" })

-- chorded/shortcut bindings
mapx("n", "<C-h>", "<C-w>h", { desc = "win:| goto |=> left", remap = true })
mapx("n", "<C-j>", "<C-w>j", { desc = "win:| goto |=> down", remap = true })
mapx("n", "<C-k>", "<C-w>k", { desc = "win:| goto |=> up", remap = true })
mapx("n", "<C-l>", "<C-w>l", { desc = "win:| goto |=> right", remap = true })

-- resize window using <ctrl> + arrow keys
mapx(
  "n",
  "<C-Up>",
  "<cmd>resize +2<cr>",
  { desc = "win.sz:| height |=> increease" }
)
mapx(
  "n",
  "<C-Down>",
  "<cmd>resize -2<cr>",
  { desc = "win.sz:| height |=> decrease" }
)
mapx(
  "n",
  "<C-Left>",
  "<cmd>vertical resize -2<cr>",
  { desc = "win.sz:| width |=> decrease" }
)
mapx(
  "n",
  "<C-Right>",
  "<cmd>vertical resize +2<cr>",
  { desc = "win.sz:| width |=> increase" }
)

mapx("n", "<leader>wxh", "<C-w>s", { desc = "win:| split => horizontal" })
mapx("n", "<leader>wxv", "<C-w>v", { desc = "win:| split => vertical" })
mapx("n", "<leader>wxx", "<C-w>v", { desc = "win:| split => vertical" })

-- leader submenu for window management
mapx(
  "n",
  "<leader>wh",
  "<C-w>h",
  { desc = "win:| goto |=> left", remap = false }
)
mapx(
  "n",
  "<leader>wj",
  "<C-w>j",
  { desc = "win:| goto |=> down", remap = false }
)
mapx(
  "n",
  "<leader>wk",
  "<C-w>k",
  { desc = "win:| goto |=> go up", remap = false }
)
mapx(
  "n",
  "<leader>wl",
  "<C-w>l",
  { desc = "win:| goto |=> right", remap = false }
)
mapx(
  "n",
  "<leader>wH",
  "<C-w>H",
  { desc = "win:| move |=> left", remap = false }
)
mapx(
  "n",
  "<leader>wJ",
  "<C-w>J",
  { desc = "win:| move |=> bottom", remap = false }
)
mapx(
  "n",
  "<leader>wK",
  "<C-w>K",
  { desc = "win:| move |=> top", remap = false }
)
mapx(
  "n",
  "<leader>wL",
  "<C-w>L",
  { desc = "win:| move |=> right", remap = false }
)
mapx(
  "n",
  "<leader>wr",
  "<C-w>r",
  { desc = "win:| rot |=> down/right", remap = false }
)
mapx(
  "n",
  "<leader>wR",
  "<C-w>R",
  { desc = "win:| rot |=> up/left", remap = false }
)
mapx(
  "n",
  "<leader>w<",
  "<C-w><",
  { desc = "win.sz:| width |=> decrease", remap = false }
)
mapx(
  "n",
  "<leader>w>",
  "<C-w>r",
  { desc = "win.sz:| width |=> increase", remap = false }
)
mapx(
  "n",
  "<leader>w-",
  "<C-w>-",
  { desc = "win.sz:| height |=> decrease", remap = false }
)
mapx(
  "n",
  "<leader>w+",
  "<C-w>+",
  { desc = "win.sz:| height |=> increase", remap = false }
)
mapx(
  "n",
  "<leader>w|",
  "<C-w>|",
  { desc = "win.sz:| width |=> maximize", remap = false }
)
mapx(
  "n",
  "<leader>w_",
  "<C-w>|",
  { desc = "win.sz:| height |=> maximize", remap = false }
)
mapx(
  "n",
  "<leader>w=",
  "<C-w>=",
  { desc = "win:| sz |=> maximize equally", remap = false }
)
mapx(
  "n",
  "<leader>wo",
  "<C-w>o",
  { desc = "win:| close |=> all other windows", remap = false }
)
mapx(
  "n",
  "<leader>wT",
  "<C-w>T",
  { desc = "win:| totab |=> new", remap = false }
)
mapx(
  "n",
  "<leader>w<tab>",
  "<C-w>T",
  { desc = "win:| totab |=> new", remap = false }
)
mapx(
  "n",
  "<leader>ww",
  "<C-W>p",
  { desc = "win:| goto |=> other", remap = true }
)
mapx(
  "n",
  "<leader>wd",
  "<C-W>c",
  { desc = "win:| close |=> this window", remap = true }
)

-- tabs
mapx("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "win:| tab |=> last" })
mapx(
  "n",
  "<leader><tab>f",
  "<cmd>tabfirst<cr>",
  { desc = "win:| tab |=> first" }
)
mapx("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "win:| tab |=> new" })
mapx(
  "n",
  "<leader><S-tab><S-tab>]",
  "<cmd>tabprevious<cr>",
  { desc = "win:| tab |=> previous" }
)
mapx(
  "n",
  "<leader><tab>c",
  "<cmd>tabclose<cr>",
  { desc = "win:| tab |=> close" }
)
mapx("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "win:| tab |=> next" })
mapx(
  "n",
  "<leader><tab>[",
  "<cmd>tabprevious<cr>",
  { desc = "win:| tab |=> previous" }
)
mapx("n", "[<tab>", "<CMD>tabprevious<CR>", { desc = "win:| tab |=> previous" })
mapx("n", "]<tab>", "<CMD>tabnext<CR>", { desc = "win:| tab |=> next" })

-- ─[ loclist and quickfix ]───────────────────────────────────────────────
-- quickfix list
mapx(
  "n",
  key_lists.quickfix.open,
  "<CMD>copen<CR>",
  { desc = "list:| qf |=> open" }
)
mapx(
  "n",
  key_lists.quickfix.next,
  "<CMD>cnext<CR>",
  { desc = "list:| qf |=> open" }
)
mapx(
  "n",
  key_lists.quickfix.last,
  "<CMD>clast<CR>",
  { desc = "list:| qf |=> open" }
)
mapx(
  "n",
  key_lists.quickfix.previous,
  "<CMD>cprev<CR>",
  { desc = "list:| qf |=> open" }
)
mapx(
  "n",
  key_lists.quickfix.first,
  "<CMD>cfirst<CR>",
  { desc = "list:| qf |=> open" }
)
mapx(
  "n",
  key_lists.quickfix.close,
  "<CMD>cclose<CR>",
  { desc = "list:| qf |=> open" }
)

-- location list
mapx(
  "n",
  key_lists.loclist.open,
  "<CMD>lopen<CR>",
  { desc = "list:| loc |=> open" }
)
mapx(
  "n",
  key_lists.loclist.next,
  "<CMD>lnext<CR>",
  { desc = "list:| loc |=> open" }
)
mapx(
  "n",
  key_lists.loclist.last,
  "<CMD>llast<CR>",
  { desc = "list:| loc |=> open" }
)
mapx(
  "n",
  key_lists.loclist.previous,
  "<CMD>lprev<CR>",
  { desc = "list:| loc |=> open" }
)
mapx(
  "n",
  key_lists.loclist.first,
  "<CMD>lfirst<CR>",
  { desc = "list:| loc |=> open" }
)
mapx(
  "n",
  key_lists.loclist.close,
  "<CMD>lclose<CR>",
  { desc = "list:| loc |=> open" }
)

-- ─[ keywordprg ]─────────────────────────────────────────────────────────
mapx(
  "n",
  "<leader>k",
  "<CMD>norm! K<CR>",
  { desc = "vim:| keywordprg |=> apply" }
)

-- ─[ better indenting ]───────────────────────────────────────────────────
mapx("v", "<", "<gv", { desc = "vim:| indent |=> decrease" })
mapx("v", ">", ">gv", { desc = "vim:| indent |=> increase" })
mapx("n", "<", "<<", { desc = "vim:| indent |=> decrease" })
mapx("n", ">", ">>", { desc = "vim:| indent |=> increase" })

-- ─[ search behavior ]────────────────────────────────────────────────────
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
mapx(
  "n",
  "n",
  "'Nn'[v:searchforward].'zv'",
  { expr = true, desc = "search:| result |=> next" }
)
mapx(
  "x",
  "n",
  "'Nn'[v:searchforward]",
  { expr = true, desc = "search:| result |=> next" }
)
mapx(
  "o",
  "n",
  "'Nn'[v:searchforward]",
  { expr = true, desc = "search:| result |=> next" }
)
mapx(
  "n",
  "N",
  "'nN'[v:searchforward].'zv'",
  { expr = true, desc = "search:| result |=> previous" }
)
mapx(
  "x",
  "N",
  "'nN'[v:searchforward]",
  { expr = true, desc = "search:| result |=> previous" }
)
mapx(
  "o",
  "N",
  "'nN'[v:searchforward]",
  { expr = true, desc = "search:| result |=> previous" }
)

-- ─[ Fat Finger Helpers ]─────────────────────────────────────────────────
-- helpers for quitting when accidentally using Shift
vim.cmd("cnoreabbrev W! w!")
vim.cmd("cnoreabbrev Q! q!")
vim.cmd("cnoreabbrev Qall! qall!")
vim.cmd("cnoreabbrev Wq wq")
vim.cmd("cnoreabbrev Wa wa")
vim.cmd("cnoreabbrev wQ wq")
vim.cmd("cnoreabbrev WQ wq")
vim.cmd("cnoreabbrev W w")
vim.cmd("cnoreabbrev q q")

-- ─[ UI bindings ]────────────────────────────────────────────────────────
-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
mapx(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "ui:| hl |=> refresh" }
)

--  under cursor inspection of highlights and extmarks.
mapx(
  "n",
  "<leader>ui",
  -- "<CMD>Inspect!<CR>",
  function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local res = vim.inspect_pos(0, row, col, {
      syntax = true,
      extmarks = true,
      treesitter = true,
      semantic_tokens = true,
    })
    require("util.newts").info(res)
  end,
  { desc = "ui:cursor| hl |=> inspect" }
)
mapx("n", "<leader>uI", vim.show_pos, { desc = "ui:cursor| hl |=> show" })

mapx("n", key_ui.spelling, function()
  toggle("spell")
end, { desc = "ui:| spell |=> toggle" })
mapx("n", key_ui.wrap, function()
  toggle("wrap")
end, { desc = "ui:| wrap |=> toggle" })
mapx("n", key_ui.numbers.relative, function()
  toggle("relativenumber")
end, { desc = "ui:| number |=> toggle rellineno" })
mapx("n", key_ui.numbers.line, function()
  toggle.number()
end, { desc = "ui:| number |=> toggle lineno" })
mapx("n", key_ui.diagnostics.toggle, function()
  toggle.diagnostics()
end, { desc = "ui:| lsp |=> toggle diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
mapx("n", key_ui.conceal, function()
  toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "ui:| conceal |=> toggle" })
mapx("n", key_ui.pinbuf, function()
  local win = vim.api.nvim_get_current_win()
  toggle.bufferpin(win)
end, { desc = "ui:| win |=> pin buffer" })
mapx("n", key_ui.treesitter, function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
  else
    vim.treesitter.start()
  end
end, { desc = "ui:| ts |=> toggle highlight" })

local scrollval = vim.o.scrolloff
mapx("n", key_ui.centerscroll, function()
  toggle("scrolloff", false, { 200 - scrollval, scrollval })
end, { desc = "ui.scroll:| vertical |=> toggle centered cursor" })

if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
  mapx("n", key_ui.inlay_hints, function()
    toggle.inlay_hints()
  end, { desc = "ui:| lsp |=> toggle inlay-hints" })
end

-- ─[ datetime insertion ]───────────────────────────────────────────────
mapx("n", "<localleader>dt", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local date = os.date("%Y-%m-%d")
  vim.api.nvim_buf_set_text(0, row, col, row, col, { date })
end, { desc = "insert date" })

-- ─[ modelines ]────────────────────────────────────────────────────────
mapx("n", "<localleader>mf", function()
  local ft = vim.bo.filetype
  local cs = vim.bo.commentstring
  vim.api.nvim_buf_set_lines(
    0,
    1,
    1,
    false,
    { cs:format(string.format("vim: set ft=%s:", ft)) }
  )
end, { remap = false })
mapx("n", "<localleader>mF", function()
  vim.ui.input(
    { prompt = "filetype: ", default = vim.bo.filetype, complete = "filetype" },
    function(sel)
      if sel == nil then
        return
      end
      local cs = vim.bo.commentstring
      vim.api.nvim_buf_set_lines(
        0,
        1,
        1,
        false,
        { cs:format(string.format("vim: set ft=%s:", sel)) }
      )
    end
  )
end)

vim.g.mc = "y/\\V<C-r>=escape(@\", '/')<CR><CR>"
-- ─[ `cn` remappings ]──────────────────────────────────────────────────
-- https://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
mapx("n", "cn", "*``cgn", { desc = "change:| next |" })
mapx("n", "cN", "*``cgN", { desc = "change:| previous |" })
mapx("v", "cn", "g:mc . '*``cgn'", { expr = true, desc = "change:| next |" })
mapx(
  "v",
  "cN",
  "g:mc . '*``cgN'",
  { expr = true, desc = "change:| previous |" }
)

local function setup_cr()
  mapx(
    "n",
    "_",
    vim.cmd(
      [[nnoremap _ n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z]]
    ),
    { buffer = true }
  )
end

mapx("n", "cq", function()
  setup_cr()
  vim.cmd([[*``qz]])
end, { remap = false, desc = "change:| next |=> macro" })
mapx("n", "cQ", function()
  setup_cr()
  vim.cmd([[#``qz]])
end, { remap = false, desc = "change:| previous |=> macro" })

-- cut, paste, copy, etc
-- send `x` results to void register
-- this avoids issues where previously copied stuff elsewhere on the system is
-- overwritten when using x to edit the location where the stuff should get
-- pasted.
mapx("n", "x", "\"_x", { desc = "`x` cut to void" })
mapx("v", "x", "\"_x", { desc = "`x` cut to void" })
mapx("n", "p", "p==", { desc = "`p` reindent" })
mapx("n", "P", "P==", { desc = "`P` reindent" })
mapx("n", "Y", "y$", { desc = "`$` yank -> EOL" })

mapx("n", "<Leader>cH", function()
  vim.cmd("vertical checkhealth")
end, { desc = "vim:| Md |=> checkhealth" })

mapx("n", "'", "<NOP>", { remap = true })
mapx("n", "`", "<NOP>", { remap = true })

mapx("n", "%%", "gg=G", { desc = "reindent" })

-- lazy.nvim mappings
mapx("n", key_lazy.open, function()
  require("lazy").home()
end, { desc = "lazy:| pkg |=> open" })
mapx("n", key_lazy.check, function()
  require("lazy").check()
end, { desc = "lazy:| pkg |=> check" })
mapx("n", key_lazy.clean, function()
  require("lazy").clean()
end, { desc = "lazy:| pkg |=> clean" })
mapx("n", key_lazy.debug, function()
  require("lazy").debug()
end, { desc = "lazy:| pkg |=> debug" })
mapx("n", key_lazy.install, function()
  require("lazy").install()
end, { desc = "lazy:| pkg |=> install" })
mapx("n", key_lazy.update, function()
  require("lazy").update()
end, { desc = "lazy:| pkg |=> update" })
mapx("n", key_lazy.sync, function()
  require("lazy").sync()
end, { desc = "lazy:| pkg |=> sync" })
mapx("n", key_lazy.profile, function()
  require("lazy").profile()
end, { desc = "lazy:| pkg |=> profile" })
mapx("n", key_lazy.log, function()
  require("lazy").log()
end, { desc = "lazy:| pkg |=> log" })
mapx("n", key_lazy.health, function()
  require("lazy").health()
end, { desc = "lazy:| pkg |=> health" })
mapx("n", key_lazy.reload, function()
  require("lazy").reload()
end, { desc = "lazy:| pkg |=> reload" })
mapx("n", key_lazy.help, function()
  require("lazy").help()
end, { desc = "lazy:| pkg |=> help" })
mapx("n", key_lazy.restore, function()
  require("lazy").restore()
end, { desc = "lazy:| pkg |=> restore" })

-- rocks.nvim mappings
-- mapx(
--   "n",
--   "<leader>re",
--   "<CMD>Rocks edit<CR>",
--   { desc = "rocks:| toml |=> edit" }
-- )
-- mapx(
--   "n",
--   "<leader>rr",
--   "<CMD>Rocks update<CR>",
--   { desc = "rocks:| pkg |=> update" }
-- )
-- mapx(
--   "n",
--   "<leader>rs",
--   "<CMD>Rocks sync<CR>",
--   { desc = "rocks:| pkg |=> sync" }
-- )
-- mapx("n", "<leader>rg", "<CMD>Rocks log<CR>", { desc = "rocks:| log |=> view" })
-- mapx("n", "<leader>ri", function()
--   vim.ui.input({ prompt = "plugin: " }, function(it)
--     vim.cmd(([[Rocks install %s dev]]):format(it))
--   end)
-- end, { desc = "rocks:| pkg |=> install" })
