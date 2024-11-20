-- options are the first things that are loaded, this is to allow the plugin
-- configurations to alter any options set here in case of conditional
-- inclusion, modular implementation details, etc.

vim.g.neostrix_debug_output = os.getenv("NEOSTRIX_DEBUG") ~= nil and true
  or false
if vim.g.neostrix_debug_output then
  vim.opt.verbose = true
  vim.opt.debug = "msg"
end

-- this is necessary to load first so that any system commands that are used in
-- the following files are correctly piped to and from the shell
require("corecfg.options.nushell")

--
-- leader configuration. These are mapped to <leader> and <localleader>
-- respectively.
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[\]]

-- Basic interface options that are not handled with specific plugin
-- configurations set in interface.lua
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"
vim.opt.backspace = "indent,eol,start"
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.startofline = false
vim.opt.confirm = true
vim.opt.visualbell = true
vim.opt.mousemoveevent = true

vim.opt.termguicolors = true

vim.opt.winminwidth = 2
vim.opt.splitkeep = "screen"
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.linebreak = true
vim.opt.list = true

-- timeout configuration for neovim mappings, affects WhichKey predominantly
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 10
vim.opt.timeoutlen = 60
vim.opt.updatetime = 50

-- set options for nvim completion menu behavior.
vim.opt.completeopt = "menuone,menu,noinsert,popup"
vim.opt.wildmode = "longest:full,full"

vim.opt.pumblend = 12
vim.opt.pumheight = 20

vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}
vim.opt.autowrite = true
vim.opt.autoread = true

-- turn on default hard word-wrapping and further extend the keys which can wrap
-- at the end of the line.
vim.opt.wrap = false
vim.opt.whichwrap:append("<,>,h,l")

-- the text that it is a part of
vim.opt.breakindent = true
vim.opt.breakindentopt:append("sbr")

vim.opt.shiftround = true

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

-- cmdline behavior.
-- * NOTE: This is generally going to be completely overhauled with noice.nvim
-- in the default implementation of nightowl.nvim
vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.cmdheight = 0

local messopts =
  { "T", "t", "a", "O", "o", "s", "w", "A", "I", "c", "C", "q", "F" }
for _, v in ipairs(messopts) do
  vim.opt.shortmess:append(v)
end

-- prevent superfluous mode messages with the other ui elements
vim.opt.showmode = false

-- Search Behavior:
-- * Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- better interactivity with search input
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.inccommand = "nosplit"

vim.opt.jumpoptions = "view"

-- see `:help hidden`
vim.opt.hidden = true

-- allows search cycling
vim.opt.wrapscan = true

-- scrolling behavior.
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

-- make ~ be an operator
vim.opt.tildeop = true

-- sign column and number column configuration
vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "auto"

-- allow cursorline, this too is generally revamped with a plugin
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- sets up the max column for syntax detection
-- see `:help synmaxcol`keep
vim.opt.syntax = "on"
vim.opt.synmaxcol = 300

-- don't use swapfiles, this really only makes sense since we have a plugin
-- which is responsible for autosaving. Set to true to reenable the default
-- behavior of using a swapfile.
-- NOTE: We could put this in a guard, e.g. a check for the existence of the
-- autosave plugin, and then if not set this to true.
vim.opt.swapfile = false

-- save undo history.
-- NOTE: In the default configuration, this behavior is enhanced with plugins.
vim.opt.undofile = true

-- spelling detection language
vim.opt.spelllang = { "en_us" }
vim.opt.spelloptions:append("noplainbuffer")

-- add an option to formatoptions
vim.opt.formatoptions:append("t")

-- use a global statusline instead of a statusline per-window.
-- * this helps to reduce clutter in the default implementation, especially
-- seeing as there is supposed to also be a winbar included per window like a
-- per-window statusline, implemented with incline.nvim
vim.opt.laststatus = 3
vim.opt.showtabline = 2

-- specify character set for the fill characters for ui divisions that are
-- filled using line-type elements.
-- see `:help fillchars`
vim.opt.fillchars:append({
  horiz = "╌",
  horizup = "┴",
  horizdown = "┬",
  vert = "╎",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
  eob = "⨳",
  stl = " ",
  stlnc = "⧠",
})

vim.cmd.hi("clear SignColumns")

vim.opt.encoding = "utf-8"

vim.cmd.filetype("plugin indent on")

vim.opt.conceallevel = 3

vim.opt.virtualedit = "block"

vim.opt.guicursor:append("n-v-c-i:blinkon400-blinkoff400")
vim.opt.smoothscroll = true

vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- disable netrw functionality
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.neostrix_debug_output = true
