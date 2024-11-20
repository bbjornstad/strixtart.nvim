local paintsak = require("util.paint")
local uienv = require("env.ui")

local keys = require("keys.aioli")

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "nvim-cmp", optional = true }, -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
      "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
    },
    opts = {
      strategies = {
        chat = {
          adapter = "anthropic",
          roles = {
            user = "ursa-major",
          },
          slash_commands = {
            ["buffer"] = {
              opts = {
                provider = "fzf_lua",
              },
            },
            ["file"] = {
              opts = {
                provider = "fzf_lua",
              },
            },
          },
        },
      },
    },
  },
  ---@module 'avante'
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | [string]
      provider = "claude", -- Only recommend using Claude
      auto_suggestions_provider = "claude",
      ---@alias Tokenizer "tiktoken" | "hf"
      -- Used for counting tokens and encoding text.
      -- By default, we will use tiktoken.
      -- For most providers that we support we will determine this automatically.
      -- If you wish to use a given implementation, then you can override it here.
      tokenizer = "tiktoken",
      ---@alias AvanteSystemPrompt string
      -- Default system prompt. Users can override this with their own prompt
      -- You can use `require('avante.config').override({system_prompt = "MY_SYSTEM_PROMPT"}) conditionally
      -- in your own autocmds to do it per directory, or that fit your needs.
      system_prompt = [[You are an excellent programming expert.]],
      ---@type AvanteSupportedProvider
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
      },
      ---@type AvanteSupportedProvider
      copilot = {
        endpoint = "https://api.githubcopilot.com",
        model = "gpt-4o-2024-05-13",
        proxy = nil, -- [protocol://]host[:port] Use this proxy
        allow_insecure = false, -- Allow insecure server connections
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
      },
      ---@type AvanteAzureProvider
      azure = {
        endpoint = "", -- example: "https://<your-resource-name>.openai.azure.com"
        deployment = "", -- Azure deployment name (e.g., "gpt-4o", "my-gpt-4o-deployment")
        api_version = "2024-06-01",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
      },
      ---@type AvanteSupportedProvider
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20240620",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 8000,
      },
      ---@type AvanteSupportedProvider
      gemini = {
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
        model = "gemini-1.5-flash-latest",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
      },
      ---@type AvanteSupportedProvider
      cohere = {
        endpoint = "https://api.cohere.com/v1",
        model = "command-r-plus-08-2024",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
      },
      ---To add support for custom provider, follow the format below
      ---See https://github.com/yetone/avante.nvim/README.md#custom-providers for more details
      ---@type {[string]: AvanteProvider}
      vendors = {},
      ---Specify the behaviour of avante.nvim
      ---1. auto_apply_diff_after_generation: Whether to automatically apply diff after LLM response.
      ---                                     This would simulate similar behaviour to cursor. Default to false.
      ---2. auto_set_keymaps                : Whether to automatically set the keymap for the current line. Default to true.
      ---                                     Note that avante will safely set these keymap. See https://github.com/yetone/avante.nvim/wiki#keymaps-and-api-i-guess for more details.
      ---3. auto_set_highlight_group        : Whether to automatically set the highlight group for the current line. Default to true.
      ---4. support_paste_from_clipboard    : Whether to support pasting image from clipboard. This will be determined automatically based whether img-clip is available or not.
      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
      history = {
        storage_path = vim.fn.stdpath("state") .. "/avante",
        paste = {
          extension = "png",
          filename = "pasted-%Y-%m-%d-%H-%M-%S",
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      mappings = {
        ---@class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-;>",
        },
        -- NOTE: The following will be safely set by avante.nvim
        ask = keys.avante.ask,
        edit = keys.avante.edit,
        refresh = keys.avante.refresh,
        toggle = {
          default = keys.avante.toggle.default,
          debug = keys.avante.toggle.debug,
          hint = keys.avante.toggle.hint,
          suggestion = keys.avante.toggle.suggestion,
        },
        sidebar = {
          switch_windows = keys.avante.sidebar.switch_windows,
          reverse_switch_windows = keys.avante.sidebar.reverse_switch_windows,
        },
      },
      windows = {
        ---@alias AvantePosition "right" | "left" | "top" | "bottom"
        position = "right",
        wrap = true, -- similar to vim.o.wrap
        width = 28, -- default % based on available width in vertical layout
        height = 40, -- default % based on available height in horizontal layout
        sidebar_header = {
          align = "left", -- left, center, right for title
          rounded = false,
        },
        input = {
          prefix = "󰘎 ",
          height = 8,
        },
        edit = {
          border = uienv.borders.main,
        },
        ask = {
          border = uienv.borders.main,
        },
      },
      --- @class AvanteConflictConfig
      diff = {
        autojump = true,
      },
      --- @class AvanteHintsConfig
      hints = {
        enabled = true,
      },
    },
    config = function(_, opts)
      require("avante").setup(opts)
      require("avante_lib").load()
    end,
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = true,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    opts = function()
      return {
        keymaps = {
          accept_suggestion = "<C-;>",
          clear_suggestion = "<C-:>",
          accept_word = "<M-;>",
        },
        ignore_filetypes = { cpp = true }, -- or { "cpp", }
        color = {
          suggestion_color = paintsak.find("@type").fg,
          cterm = 244,
        },
        -- set to "off" to disable logging completely
        log_level = "info",
        -- disables inline completion for use with cmp
        disable_inline_completion = false,
        -- disables built in keymaps for more manual control
        disable_keymaps = false,
        condition = function()
          return false
        end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
      }
    end,
  },
  {
    "Robitx/gp.nvim",
    opts = function()
      return {
        -- Please start with minimal config possible.
        -- Just openai_api_key if you don't have OPENAI_API_KEY env set up.
        -- Defaults change over time to improve things, options might get deprecated.
        -- It's better to change only things where the default doesn't fit your needs.

        -- required openai api key (string or table with command and arguments)
        -- openai_api_key = { "cat", "path_to/openai_api_key" },
        -- openai_api_key = { "bw", "get", "password", "OPENAI_API_KEY" },
        -- openai_api_key: "sk-...",
        -- openai_api_key = os.getenv("env_name.."),
        openai_api_key = os.getenv("OPENAI_API_KEY"),

        -- at least one working provider is required
        -- to disable a provider set it to empty table like openai = {}
        providers = {
          -- secrets can be strings or tables with command and arguments
          -- secret = { "cat", "path_to/openai_api_key" },
          -- secret = { "bw", "get", "password", "OPENAI_API_KEY" },
          -- secret : "sk-...",
          -- secret = os.getenv("env_name.."),
          openai = {
            disable = false,
            endpoint = "https://api.openai.com/v1/chat/completions",
            -- secret = os.getenv("OPENAI_API_KEY"),
          },
          azure = {
            disable = true,
            endpoint = "https://$URL.openai.azure.com/openai/deployments/{{model}}/chat/completions",
            secret = os.getenv("AZURE_API_KEY"),
          },
          copilot = {
            disable = true,
            endpoint = "https://api.githubcopilot.com/chat/completions",
            secret = {
              "bash",
              "-c",
              "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
            },
          },
          ollama = {
            disable = true,
            endpoint = "http://localhost:11434/v1/chat/completions",
            secret = "dummy_secret",
          },
          lmstudio = {
            disable = true,
            endpoint = "http://localhost:1234/v1/chat/completions",
            secret = "dummy_secret",
          },
          googleai = {
            disable = true,
            endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
            secret = os.getenv("GOOGLEAI_API_KEY"),
          },
          pplx = {
            disable = true,
            endpoint = "https://api.perplexity.ai/chat/completions",
            secret = os.getenv("PPLX_API_KEY"),
          },
          anthropic = {
            disable = true,
            endpoint = "https://api.anthropic.com/v1/messages",
            secret = os.getenv("ANTHROPIC_API_KEY"),
          },
        },

        -- prefix for all commands
        cmd_prefix = "Gp",
        -- optional curl parameters (for proxy, etc.)
        -- curl_params = { "--proxy", "http://X.X.X.X:XXXX" }
        curl_params = {},

        -- log file location
        log_file = vim.fn.stdpath("log"):gsub("/$", "") .. "/gp.nvim.log",
        -- write sensitive data to log file for	debugging purposes (like api keys)
        log_sensitive = false,

        -- directory for persisting state dynamically changed by user (like model or persona)
        state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/persisted",

        -- default agent names set during startup, if nil last used agent is used
        default_command_agent = nil,
        default_chat_agent = nil,

        -- default command agents (model + persona)
        -- name, model and system_prompt are mandatory fields
        -- to use agent for chat set chat = true, for command set command = true
        -- to remove some default agent completely set it like:
        -- agents = {  { name = "ChatGPT3-5", disable = true, }, ... },
        agents = {
          {
            name = "ExampleDisabledAgent",
            disable = true,
          },
          {
            name = "ChatGPT4o",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "openai",
            name = "ChatGPT4o-mini",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o-mini", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "copilot",
            name = "ChatCopilot",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "googleai",
            name = "ChatGemini",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "gemini-pro", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "pplx",
            name = "ChatPerplexityLlama3.1-8B",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = {
              model = "llama-3.1-sonar-small-128k-chat",
              temperature = 1.1,
              top_p = 1,
            },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "anthropic",
            name = "ChatClaude-3-5-Sonnet",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = {
              model = "claude-3-5-sonnet-20240620",
              temperature = 0.8,
              top_p = 1,
            },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "anthropic",
            name = "ChatClaude-3-Haiku",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = {
              model = "claude-3-haiku-20240307",
              temperature = 0.8,
              top_p = 1,
            },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "ollama",
            name = "ChatOllamaLlama3.1-8B",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = {
              model = "llama3.1",
              temperature = 0.6,
              top_p = 1,
              min_p = 0.05,
            },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are a general AI assistant.",
          },
          {
            provider = "lmstudio",
            name = "ChatLMStudio",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = {
              model = "dummy",
              temperature = 0.97,
              top_p = 1,
              num_ctx = 8192,
            },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are a general AI assistant.",
          },
          {
            provider = "openai",
            name = "CodeGPT4o",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o", temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "openai",
            name = "CodeGPT4o-mini",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o-mini", temperature = 0.7, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```",
          },
          {
            provider = "copilot",
            name = "CodeCopilot",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o", temperature = 0.8, top_p = 1, n = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "googleai",
            name = "CodeGemini",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gemini-pro", temperature = 0.8, top_p = 1 },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "pplx",
            name = "CodePerplexityLlama3.1-8B",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = {
              model = "llama-3.1-sonar-small-128k-chat",
              temperature = 0.8,
              top_p = 1,
            },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "anthropic",
            name = "CodeClaude-3-5-Sonnet",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = {
              model = "claude-3-5-sonnet-20240620",
              temperature = 0.8,
              top_p = 1,
            },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "anthropic",
            name = "CodeClaude-3-Haiku",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = {
              model = "claude-3-haiku-20240307",
              temperature = 0.8,
              top_p = 1,
            },
            system_prompt = require("gp.defaults").code_system_prompt,
          },
          {
            provider = "ollama",
            name = "CodeOllamaLlama3.1-8B",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = {
              model = "llama3.1",
              temperature = 0.4,
              top_p = 1,
              min_p = 0.05,
            },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require("gp.defaults").code_system_prompt,
          },
        },

        -- directory for storing chat files
        chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
        -- chat user prompt prefix
        chat_user_prefix = "💬:",
        -- chat assistant prompt prefix (static string or a table {static, template})
        -- first string has to be static, second string can contain template {{agent}}
        -- just a static string is legacy and the [{{agent}}] element is added automatically
        -- if you really want just a static string, make it a table with one element { "🤖:" }
        chat_assistant_prefix = { "🤖:", "[{{agent}}]" },
        -- The banner shown at the top of each chat file.
        chat_template = require("gp.defaults").chat_template,
        -- if you want more real estate in your chat files and don't need the helper text
        -- chat_template = require("gp.defaults").short_chat_template,
        -- chat topic generation prompt
        chat_topic_gen_prompt = "Summarize the topic of our conversation above"
          .. " in two or three words. Respond only with those words.",
        -- chat topic model (string with model name or table with model name and parameters)
        -- explicitly confirm deletion of a chat file
        chat_confirm_delete = true,
        -- conceal model parameters in chat
        chat_conceal_model_params = true,
        -- local shortcuts bound to the chat buffer
        -- (be careful to choose something which will work across specified modes)
        chat_shortcut_respond = {
          modes = { "n", "i", "v", "x" },
          shortcut = "<C-g><C-g>",
        },
        chat_shortcut_delete = {
          modes = { "n", "i", "v", "x" },
          shortcut = "<C-g>d",
        },
        chat_shortcut_stop = {
          modes = { "n", "i", "v", "x" },
          shortcut = "<C-g>s",
        },
        chat_shortcut_new = {
          modes = { "n", "i", "v", "x" },
          shortcut = "<C-g>c",
        },
        -- default search term when using :GpChatFinder
        chat_finder_pattern = "topic ",
        chat_finder_mappings = {
          delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-d>" },
        },
        -- if true, finished ChatResponder won't move the cursor to the end of the buffer
        chat_free_cursor = false,
        -- use prompt buftype for chats (:h prompt-buffer)
        chat_prompt_buf_type = false,

        -- how to display GpChatToggle or GpContext
        ---@type "popup" | "split" | "vsplit" | "tabnew"
        toggle_target = "vsplit",

        -- styling for chatfinder
        ---@type "single" | "double" | "rounded" | "solid" | "shadow" | "none"
        style_chat_finder_border = "single",
        -- margins are number of characters or lines
        style_chat_finder_margin_bottom = 8,
        style_chat_finder_margin_left = 1,
        style_chat_finder_margin_right = 2,
        style_chat_finder_margin_top = 2,
        -- how wide should the preview be, number between 0.0 and 1.0
        style_chat_finder_preview_ratio = 0.5,

        -- styling for popup
        ---@type "single" | "double" | "rounded" | "solid" | "shadow" | "none"
        style_popup_border = "single",
        -- margins are number of characters or lines
        style_popup_margin_bottom = 8,
        style_popup_margin_left = 1,
        style_popup_margin_right = 2,
        style_popup_margin_top = 2,
        style_popup_max_width = 160,

        -- in case of visibility colisions with other plugins, you can increase/decrease zindex
        zindex = 49,

        -- command config and templates below are used by commands like GpRewrite, GpEnew, etc.
        -- command prompt prefix for asking user for input (supports {{agent}} template variable)
        command_prompt_prefix_template = "🤖 {{agent}} ~ ",
        -- auto select command response (easier chaining of commands)
        -- if false it also frees up the buffer cursor for further editing elsewhere
        command_auto_select_response = true,

        -- templates
        template_selection = "I have the following from {{filename}}:"
          .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}",
        template_rewrite = "I have the following from {{filename}}:"
          .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
          .. "\n\nRespond exclusively with the snippet that should replace the selection above.",
        template_append = "I have the following from {{filename}}:"
          .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
          .. "\n\nRespond exclusively with the snippet that should be appended after the selection above.",
        template_prepend = "I have the following from {{filename}}:"
          .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
          .. "\n\nRespond exclusively with the snippet that should be prepended before the selection above.",
        template_command = "{{command}}",

        -- https://platform.openai.com/docs/guides/speech-to-text/quickstart
        -- Whisper costs $0.006 / minute (rounded to the nearest second)
        -- by eliminating silence and speeding up the tempo of the recording
        -- we can reduce the cost by 50% or more and get the results faster

        whisper = {
          -- you can disable whisper completely by whisper = {disable = true}
          disable = false,

          -- OpenAI audio/transcriptions api endpoint to transcribe audio to text
          endpoint = "https://api.openai.com/v1/audio/transcriptions",
          -- directory for storing whisper files
          store_dir = (os.getenv("TMPDIR") or os.getenv("TEMP") or "/tmp")
            .. "/gp_whisper",
          -- multiplier of RMS level dB for threshold used by sox to detect silence vs speech
          -- decibels are negative, the recording is normalized to -3dB =>
          -- increase this number to pick up more (weaker) sounds as possible speech
          -- decrease this number to pick up only louder sounds as possible speech
          -- you can disable silence trimming by setting this a very high number (like 1000.0)
          silence = "1.75",
          -- whisper tempo (1.0 is normal speed)
          tempo = "1.75",
          -- The language of the input audio, in ISO-639-1 format.
          language = "en",
          -- command to use for recording can be nil (unset) for automatic selection
          -- string ("sox", "arecord", "ffmpeg") or table with command and arguments:
          -- sox is the most universal, but can have start/end cropping issues caused by latency
          -- arecord is linux only, but has no cropping issues and is faster
          -- ffmpeg in the default configuration is macos only, but can be used on any platform
          -- (see https://trac.ffmpeg.org/wiki/Capture/Desktop for more info)
          -- below is the default configuration for all three commands:
          -- whisper_rec_cmd = {"sox", "-c", "1", "--buffer", "32", "-d", "rec.wav", "trim", "0", "60:00"},
          -- whisper_rec_cmd = {"arecord", "-c", "1", "-f", "S16_LE", "-r", "48000", "-d", "3600", "rec.wav"},
          -- whisper_rec_cmd = {"ffmpeg", "-y", "-f", "avfoundation", "-i", ":0", "-t", "3600", "rec.wav"},
          rec_cmd = nil,
        },

        -- image generation settings
        image = {
          -- you can disable image generation logic completely by image = {disable = true}
          disable = false,

          -- openai api key (string or table with command and arguments)
          -- secret = { "cat", "path_to/openai_api_key" },
          -- secret = { "bw", "get", "password", "OPENAI_API_KEY" },
          -- secret =  "sk-...",
          -- secret = os.getenv("env_name.."),
          -- if missing openai_api_key is used
          secret = os.getenv("OPENAI_API_KEY"),

          -- image prompt prefix for asking user for input (supports {{agent}} template variable)
          prompt_prefix_template = "🖌️ {{agent}} ~ ",
          -- image prompt prefix for asking location to save the image
          prompt_save = "🖌️💾 ~ ",
          -- default folder for saving images
          store_dir = (os.getenv("TMPDIR") or os.getenv("TEMP") or "/tmp")
            .. "/gp_images",
          -- default image agents (model + settings)
          -- to remove some default agent completely set it like:
          -- image.agents = {  { name = "DALL-E-3-1024x1792-vivid", disable = true, }, ... },
          agents = {
            {
              name = "ExampleDisabledAgent",
              disable = true,
            },
            {
              name = "DALL-E-3-1024x1024-vivid",
              model = "dall-e-3",
              quality = "standard",
              style = "vivid",
              size = "1024x1024",
            },
            {
              name = "DALL-E-3-1792x1024-vivid",
              model = "dall-e-3",
              quality = "standard",
              style = "vivid",
              size = "1792x1024",
            },
            {
              name = "DALL-E-3-1024x1792-vivid",
              model = "dall-e-3",
              quality = "standard",
              style = "vivid",
              size = "1024x1792",
            },
            {
              name = "DALL-E-3-1024x1024-natural",
              model = "dall-e-3",
              quality = "standard",
              style = "natural",
              size = "1024x1024",
            },
            {
              name = "DALL-E-3-1792x1024-natural",
              model = "dall-e-3",
              quality = "standard",
              style = "natural",
              size = "1792x1024",
            },
            {
              name = "DALL-E-3-1024x1792-natural",
              model = "dall-e-3",
              quality = "standard",
              style = "natural",
              size = "1024x1792",
            },
            {
              name = "DALL-E-3-1024x1024-vivid-hd",
              model = "dall-e-3",
              quality = "hd",
              style = "vivid",
              size = "1024x1024",
            },
            {
              name = "DALL-E-3-1792x1024-vivid-hd",
              model = "dall-e-3",
              quality = "hd",
              style = "vivid",
              size = "1792x1024",
            },
            {
              name = "DALL-E-3-1024x1792-vivid-hd",
              model = "dall-e-3",
              quality = "hd",
              style = "vivid",
              size = "1024x1792",
            },
            {
              name = "DALL-E-3-1024x1024-natural-hd",
              model = "dall-e-3",
              quality = "hd",
              style = "natural",
              size = "1024x1024",
            },
            {
              name = "DALL-E-3-1792x1024-natural-hd",
              model = "dall-e-3",
              quality = "hd",
              style = "natural",
              size = "1792x1024",
            },
            {
              name = "DALL-E-3-1024x1792-natural-hd",
              model = "dall-e-3",
              quality = "hd",
              style = "natural",
              size = "1024x1792",
            },
          },
        },

        -- example hook functions (see Extend functionality section in the README)
        hooks = {
          -- GpInspectPlugin provides a detailed inspection of the plugin state
          InspectPlugin = function(plugin, params)
            local bufnr = vim.api.nvim_create_buf(false, true)
            local copy = vim.deepcopy(plugin)
            local key = copy.config.openai_api_key or ""
            copy.config.openai_api_key = key:sub(1, 3)
              .. string.rep("*", #key - 6)
              .. key:sub(-3)
            local plugin_info =
              string.format("Plugin structure:\n%s", vim.inspect(copy))
            local params_info =
              string.format("Command params:\n%s", vim.inspect(params))
            local lines = vim.split(plugin_info .. "\n" .. params_info, "\n")
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_win_set_buf(0, bufnr)
          end,

          -- GpInspectLog for checking the log file
          InspectLog = function(plugin, params)
            local log_file = plugin.config.log_file
            local buffer = plugin.helpers.get_buffer(log_file)
            if not buffer then
              vim.cmd("e " .. log_file)
            else
              vim.cmd("buffer " .. buffer)
            end
          end,

          -- GpImplement rewrites the provided selection/range based on comments in it
          Implement = function(gp, params)
            local template = "Having following from {{filename}}:\n\n"
              .. "```{{filetype}}\n{{selection}}\n```\n\n"
              .. "Please rewrite this according to the contained instructions."
              .. "\n\nRespond exclusively with the snippet that should replace the selection above."

            local agent = gp.get_command_agent()
            gp.logger.info("Implementing selection with agent: " .. agent.name)

            gp.Prompt(
              params,
              gp.Target.rewrite,
              agent,
              template,
              nil, -- command will run directly without any prompting for user input
              nil -- no predefined instructions (e.g. speech-to-text from Whisper)
            )
          end,

          -- your own functions can go here, see README for more examples like
          -- :GpExplain, :GpUnitTests.., :GpTranslator etc.

          -- -- example of making :%GpChatNew a dedicated command which
          -- -- opens new chat with the entire current buffer as a context
          -- BufferChatNew = function(gp, _)
          -- 	-- call GpChatNew command in range mode on whole buffer
          -- 	vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
          -- end,

          -- -- example of adding command which opens new chat dedicated for translation
          -- Translator = function(gp, params)
          -- 	local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
          -- 	gp.cmd.ChatNew(params, chat_system_prompt)
          --
          -- 	-- -- you can also create a chat with a specific fixed agent like this:
          -- 	-- local agent = gp.get_chat_agent("ChatGPT4o")
          -- 	-- gp.cmd.ChatNew(params, chat_system_prompt, agent)
          -- end,

          -- -- example of adding command which writes unit tests for the selected code
          -- UnitTests = function(gp, params)
          -- 	local template = "I have the following code from {{filename}}:\n\n"
          -- 		.. "```{{filetype}}\n{{selection}}\n```\n\n"
          -- 		.. "Please respond by writing table driven unit tests for the code above."
          -- 	local agent = gp.get_command_agent()
          -- 	gp.Prompt(params, gp.Target.enew, agent, template)
          -- end,

          -- -- example of adding command which explains the selected code
          -- Explain = function(gp, params)
          -- 	local template = "I have the following code from {{filename}}:\n\n"
          -- 		.. "```{{filetype}}\n{{selection}}\n```\n\n"
          -- 		.. "Please respond by explaining the code above."
          -- 	local agent = gp.get_chat_agent()
          -- 	gp.Prompt(params, gp.Target.popup, agent, template)
          -- end,
        },
      }
    end,
  },
  {
    "joshuavial/aider.nvim",
    opts = {
      auto_manage_context = true,
      default_bindings = true,
    },
    cmd = { "AiderOpen", "AdierBackground" },
  },
}
