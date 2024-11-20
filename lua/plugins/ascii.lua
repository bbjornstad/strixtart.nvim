local env = require("env.ui")
local key_editor = require("keys.editor")
local key_cbox = key_editor.cbox
local key_cline = key_editor.cline
local key_figlet = key_editor.figlet
local key_venn = key_editor.venn
local key_cframe = key_editor.comment_frame

local function font_selector(callback)
  return function()
    local figlet_fontdir = vim.fs.normalize("/usr/share/figlet")
    local fonts = vim.iter(vim.fs.dir(figlet_fontdir)):totable()
    vim.ui.select(fonts, {
      prompt = "figlet fonts: ",
      format_item = function(item)
        return string.gsub(item.name, ".flf", "")
      end,
    }, callback)
  end
end

-- ─[ comment divisions selector functions ]─────────────────────────────

local function box_selector(boxid)
  return function()
    local fn = function(num)
      vim.cmd(([[CB%sbox%s]]):format(boxid, num))
    end
    local mapper = {
      "rounded",
      "classic",
      "classic heavy",
      "dashed",
      "dashed heavy",
      "mix heavy/light",
      "double",
      "mix double/single a",
      "mix double/single b",
      "ascii",
      "quote a",
      "quote b",
      "quote c",
      "marked a",
      "marked b",
      "marked c",
      "vertically enclosed a",
      "vertically enclosed b",
      "vertically enclosed c",
      "horizontally enclosed a",
      "horizontally enclosed b",
      "horizontally enclosed c",
    }
    vim.ui.select(mapper, {
      prompt = "󰺫 box type: ",
      format_item = function(item)
        return "󱅃  " .. item
      end,
    }, function(choice, num)
      if not choice then
        return
      end
      return fn(num)
    end)
  end
end

local function line_selector(lineid)
  return function()
    local fn = function(num)
      vim.cmd(([[CB%sline%s]]):format(lineid, num))
    end
    local mapper = {
      "simple",
      "simple: round down",
      "simple: round up",
      "simple: square down",
      "simple: square up",
      "simple: squared title",
      "simple: rounded title",
      "simple: spiked title",
      "simple: heavy",
      "confined",
      "confined heavy",
      "simple weighted",
      "double",
      "double confined",
      "ascii a",
      "ascii b",
      "ascii c",
    }
    vim.ui.select(mapper, {
      prompt = "󰘤 line type: ",
      format_item = function(item)
        return "󰕞  " .. item
      end,
    }, function(choice, num)
      if not choice then
        return
      end
      return fn(num)
    end)
  end
end

return {
  {
    "LudoPinelli/comment-box.nvim",
    opts = {
      doc_width = 80,
      box_width = 72,
      line_width = 72,
      comment_style = "auto",
      outer_blank_lines_above = true,
      outer_blank_lines_below = false,
      inner_blank_lines = false,
      line_blank_line_above = true,
      line_blank_line_below = false,
    },
    keys = vim.tbl_map(function(subt)
      return vim.tbl_deep_extend(
        "force",
        subt,
        { remap = false, silent = false }
      )
    end, {
      {
        key_cbox.catalog,
        function()
          require("comment-box").catalog()
        end,
        mode = { "n", "v" },
        desc = "box=> catalog",
      },
      {
        key_cbox.pos_left.align_left,
        box_selector("ll"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉢 |=> 󱄽:󰉢",
      },
      {
        key_cbox.pos_left.align_center,
        box_selector("lc"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉢 |=> 󱄽:󰉠",
      },
      {
        key_cbox.pos_left.align_right,
        box_selector("lr"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉢 |=> 󱄽:󰉣",
      },
      {
        key_cbox.pos_center.align_left,
        box_selector("cl"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉠 |=> 󱄽:󰉢",
      },
      {
        key_cbox.pos_center.align_center,
        box_selector("cc"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉠 |=> 󱄽:󰉠",
      },
      {
        key_cbox.pos_center.align_right,
        box_selector("cr"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉠 |=> 󱄽:󰉣",
      },
      {
        key_cbox.pos_right.align_left,
        box_selector("rl"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉣 |=> 󱄽:󰉢",
      },
      {
        key_cbox.pos_right.align_center,
        box_selector("rc"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉣 |=> 󱄽:󰉠",
      },
      {
        key_cbox.pos_right.align_right,
        box_selector("rr"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰉣 |=> 󱄽:󰉣",
      },
      {
        key_cbox.adaptive.align_left,
        box_selector("la"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰡎 |=> 󱄽:󰉢",
      },
      {
        key_cbox.adaptive.align_center,
        box_selector("ca"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰡎 |=> 󱄽:󰉠",
      },
      {
        key_cbox.adaptive.align_right,
        box_selector("ra"),
        mode = { "n", "v" },
        desc = "box:| 󰘷:󰡎 |=> 󱄽:󰉣",
      },
      {
        key_cline.align_left.text_left,
        line_selector("ll"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉢 |=> 󱄽:󰉢",
      },
      {
        key_cline.align_left.text_center,
        line_selector("lc"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉢 |=> 󱄽:󰉠",
      },
      {
        key_cline.align_left.text_right,
        line_selector("lr"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉢 |=> 󱄽:󰉣",
      },
      {
        key_cline.align_center.text_left,
        line_selector("cl"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉠 |=> 󱄽:󰉢",
      },
      {
        key_cline.align_center.text_center,
        line_selector("cc"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉠 |=> 󱄽:󰉠",
      },
      {
        key_cline.align_center.text_right,
        line_selector("cr"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉠 |=> 󱄽:󰉣",
      },
      {
        key_cline.align_right.text_left,
        line_selector("rl"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉣 |=> 󱄽:󰉢",
      },
      {
        key_cline.align_right.text_center,
        line_selector("rc"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉣 |=> 󱄽:󰉠",
      },
      {
        key_cline.align_right.text_right,
        line_selector("rr"),
        mode = { "n", "v" },
        desc = "line:| 󰘷:󰉣 |=> 󱄽:󰉣",
      },
    }),
  },
  {
    "thazelart/figban.nvim",
    config = function(_, opts)
      vim.g.figban_fontstyle = env.figlet.font.default
    end,
    cmd = "Figban",
    keys = {
      {
        -- somehow we would ideally like this keymapping to have completion items
        -- which are the selection of figlet fonts that are available on theme
        -- system
        --
        key_figlet.banner.change_font,
        font_selector(function(input)
          vim.g.figban_fontstyle = input
          vim.notify(("Assigned Figlet Font: %s"):format(input))
        end),
        mode = { "n" },
        desc = "figlet:| banner |=> select font",
      },
      {
        key_figlet.banner.generate,
        function()
          vim.ui.input({ prompt = "banner text: " }, function(input)
            vim.cmd(([[Figban %s]]):format(input))
          end)
        end,
        mode = "n",
        desc = "figlet:| banner |=> generate",
      },
    },
  },
  {
    "jbyuki/venn.nvim",
    cmd = "VBox",
    config = false,
    init = function()
      -- venn.nvim: enable or disable keymappings
      local function ToggleVenn()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
          vim.b.venn_enabled = true
          vim.cmd([[setlocal ve=all]])
          -- draw a line on HJKL keystokes
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "J",
            "<C-v>j:VBox<CR>",
            { noremap = true }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "K",
            "<C-v>k:VBox<CR>",
            { noremap = true }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "L",
            "<C-v>l:VBox<CR>",
            { noremap = true }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "H",
            "<C-v>h:VBox<CR>",
            { noremap = true }
          )
          -- draw a box by pressing "f" with visual selection
          vim.api.nvim_buf_set_keymap(
            0,
            "v",
            "f",
            ":VBox<CR>",
            { noremap = true }
          )
        else
          vim.cmd([[setlocal virtualedit]])
          vim.cmd([[mapclear <buffer>]])
          vim.b.venn_enabled = nil
        end
      end

      vim.keymap.set("n", key_venn, function()
        ToggleVenn()
      end, { noremap = true, desc = "ascii:| venn |=> toggle" })
      -- toggle keymappings for venn using <leader>v
    end,
  },
  {
    "s1n7ax/nvim-comment-frame",
    opts = {
      disable_default_keymap = true,
      keymap = key_cframe.single_line,
      multiline_keymap = key_cframe.multi_line,
      start_str = ">>",
      end_str = "<<",
      fill_char = "=",
      frame_width = 72,
      line_wrap_len = 64,
      add_comment_above = true,
      auto_indent = true,
    },
  },
}
