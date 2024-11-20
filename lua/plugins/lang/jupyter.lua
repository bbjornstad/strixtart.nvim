local key_python = require("keys.lang").python

return {
  {
    "geg2102/nvim-jupyter-client",
    ft = { "ipynb" },
    cmd = {
      "JupyterAddCellBelow",
      "JupyterAddCellAbove",
      "JupyterRemoveCell",
      "JupyterMergeCellAbove",
      "JupyterMergeCellBelow",
      "JupyterConvertCellType",
    },
    opts = {
      template = {
        cells = {
          {
            cell_type = "code",
            execution_count = nil,
            metadata = {},
            outputs = {},
            source = { "# Custom template cell\n" },
          },
        },
        metadata = {
          kernelspec = {
            display_name = "Python 3",
            language = "python",
            name = "python3",
          },
        },
        nbformat = 4,
        nbformat_minor = 5,
      },
      cell_highlight_group = "CurSearch", --whatever you want here
      -- If custom highlight group then set these manually
      highlights = {
        cell_title = {
          ctermfg = "#ffffff",
          ctermbg = "#000000",
          bold = true,
        },
      },
    },
    keys = {
      {
        key_python.jupyter.add_cell_above,
        "<CMD>JupyterAddCellAbove<CR>",
        mode = "n",
        desc = "add cell above",
      },
      {
        key_python.jupyter.add_cell_below,
        "<CMD>JupyterAddCellBelow<CR>",
        mode = "n",
        desc = "add cell below",
      },
      {
        key_python.jupyter.remove_cell,
        "<CMD>JupyterRemoveCell<CR>",
        mode = "n",
        desc = "remove cell",
      },
      {
        key_python.jupyter.merge_cell_above,
        "<CMD>JupyterMergeCellAbove<CR>",
        mode = "n",
        desc = "merge cell above",
      },
      {
        key_python.jupyter.merge_cell_below,
        "<CMD>JupyterMergeCellBelow<CR>",
        mode = "n",
        desc = "merge cell below",
      },
      {
        key_python.jupyter.convert_cell_type,
        "<CMD>JupyterConvertCellType<CR>",
        mode = "n",
        desc = "convert cell type",
      },
    },
  },
}
