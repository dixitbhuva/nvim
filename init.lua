vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0


----- LEADER KEY -----
vim.g.mapleader = " "
vim.g.maplocalleader = " "

----- BASIC OPTIONS -----
vim.opt.updatetime = 50
vim.opt.guicursor = ""
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.backspace = "indent,eol,start"
vim.opt.clipboard:append("unnamedplus")
vim.opt.splitright = true
vim.opt.splitbelow = true

----- BASIC KEYMAPS -----
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { desc = "Navigate vim panes to k/up" })
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { desc = "Navigate vim panes to j/down" })
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { desc = "Navigate vim panes to h/left" })
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { desc = "Navigate vim panes to l/right" })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-------------------------------------------------------------------------------
-------------------- LAZY PLUGIN MANAGER AND PLUGIN CONFIGS -------------------
-------------------------------------------------------------------------------

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here

    {
      "folke/tokyonight.nvim",
      priority = 1000, -- Load before other plugins
      config = function()
        local bg = "#011628"
        local bg_dark = "#011423"
        local bg_highlight = "#143652"
        local bg_search = "#0A64AC"
        local bg_visual = "#275378"
        local fg = "#CBE0F0"
        local fg_dark = "#B4D0E9"
        local fg_gutter = "#627E97"
        local border = "#547998"

        require("tokyonight").setup({
          style = "night",
          on_colors = function(colors)
            colors.bg = bg
            colors.bg_dark = bg_dark
            colors.bg_float = bg_dark
            colors.bg_highlight = bg_highlight
            colors.bg_popup = bg_dark
            colors.bg_search = bg_search
            colors.bg_sidebar = bg_dark
            colors.bg_statusline = bg_dark
            colors.bg_visual = bg_visual
            colors.border = border
            colors.fg = fg
            colors.fg_dark = fg_dark
            colors.fg_float = fg
            colors.fg_gutter = fg_gutter
            colors.fg_sidebar = fg_dark
          end,
        })
        -- Load the colorscheme
        vim.cmd([[colorscheme tokyonight]])
      end,
    },

    {
      "nvim-lualine/lualine.nvim",
      dependencies = { { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font } },
      config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status") -- Lazy updates count

        -- Colors
        local colors = {
          blue = "#65D1FF",
          green = "#3EFFDC",
          violet = "#FF61EF",
          yellow = "#FFDA7B",
          red = "#FF4A4A",
          fg = "#c3ccdc",
          bg = "#112638",
          inactive_bg = "#2c3043",
        }

        -- Custom Lualine Theme
        local my_lualine_theme = {
          normal = {
            a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          insert = {
            a = { bg = colors.green, fg = colors.bg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          visual = {
            a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          command = {
            a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          replace = {
            a = { bg = colors.red, fg = colors.bg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          inactive = {
            a = { bg = colors.inactive_bg, fg = colors.fg, gui = "bold" },
            b = { bg = colors.inactive_bg, fg = colors.fg },
            c = { bg = colors.inactive_bg, fg = colors.fg },
          },
        }

        -- Configure Lualine
        lualine.setup({
          options = {
            theme = my_lualine_theme,
            section_separators = "",
            component_separators = "",
          },
          sections = {
            lualine_x = {
              {
                lazy_status.updates, -- Fixed function call
                cond = lazy_status.has_updates, -- Fixed function call
                color = { fg = "#ff9e64" },
              },
              { "encoding" },
              { "fileformat" },
              { "filetype" },
            },
          },
        })
      end,
    },

    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
        "nvim-telescope/telescope-ui-select.nvim",
      },
      config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
          defaults = {
            path_display = { "smart" },
            mappings = {
              i = {
                ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                ["<C-j>"] = actions.move_selection_next,     -- move to next result
              },
            },
          },
          extensions = {
            ["ui-select"] = {
              require("telescope.themes").get_dropdown({})
            },
          },
        })

        -- Load extensions
        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")

        -- Keymaps
        vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files in cwd" })
        vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Find recent files" })
        vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
        vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor" })
      end,
    },


    {
      "nvim-treesitter/nvim-treesitter",
      event = { "BufReadPre", "BufNewFile" },
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = "all", -- Install all supported parsers
          highlight = { enable = true },
          indent = { enable = true },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<C-space>",
              node_incremental = "<C-space>",
              scope_incremental = false,
              node_decremental = "<bs>",
            },
          },
        })
      end,
    },

    -- Treesitter Auto Tag
    {
      "windwp/nvim-ts-autotag",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("nvim-ts-autotag").setup({
          enable = true,
        })
      end,
    },



    -- Essential Plugins Setup (LSP, Completion, Snippets, etc.)
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "hrsh7th/nvim-cmp",          -- Completion plugin
        "hrsh7th/cmp-nvim-lsp",      -- LSP completion source
        "hrsh7th/cmp-buffer",        -- Buffer completion
        "hrsh7th/cmp-path",          -- Path completion
        "hrsh7th/cmp-cmdline",       -- Command-line completion
        "L3MON4D3/LuaSnip",          -- Snippet engine
        "saadparwaiz1/cmp_luasnip",  -- Snippet completions
        "rafamadriz/friendly-snippets", -- Predefined snippets
        "williamboman/mason.nvim",   -- LSP installer
        "williamboman/mason-lspconfig.nvim", -- Auto LSP setup
        "github/copilot.vim",        -- GitHub Copilot integration
        "mattn/emmet-vim",           -- Emmet plugin for HTML/CSS
      },
      config = function()
        -- Set up Mason and Mason-LSP
        require("mason").setup()
        require("mason-lspconfig").setup({
          ensure_installed = { "html", "cssls", "ts_ls", "eslint", "intelephense" }, -- List LSPs to install
        })

        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- LSP Setup
        lspconfig.html.setup({ capabilities = capabilities })
        lspconfig.cssls.setup({ capabilities = capabilities })
        lspconfig.ts_ls.setup({ capabilities = capabilities }) -- tsserver replaced by ts_ls
        lspconfig.eslint.setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        })
                lspconfig.intelephense.setup({ capabilities = capabilities })


        -- Snippets Setup
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load() -- Load VSCode snippets

        -- Autocompletion Setup
        local cmp = require("cmp")
        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body) -- Use LuaSnip to expand snippets
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping.select_next_item(),        -- Next completion
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),      -- Previous completion
            ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm completion
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },     -- LSP completion
            { name = "buffer" },       -- Buffer completion
            { name = "path" },         -- Path completion
            { name = "luasnip" },      -- Snippet completion
          }),
        })

        -- Emmet Setup (for HTML/CSS)
        vim.g.user_emmet_mode = "n"  -- Enable Emmet in normal mode
        vim.g.user_emmet_leader_key = "<C-e>"  -- Set Emmet leader key

        -- CodeSnippets setup using friendly-snippets
        require("luasnip.loaders.from_vscode").lazy_load() -- Load snippets from vscode-style sources

        -- Keybindings for LSP
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

        -- Enable GitHub Copilot
        vim.g.copilot_enabled = true  -- Enable Copilot after the plugin is loaded

        -- Auto completion for HTML/CSS with Emmet
        vim.keymap.set("i", "<C-e>", "<Plug>(emmet-expand-abbr)", { silent = true, noremap = true })
      end,
    },


    {
      "tpope/vim-dispatch",
      config = function()
        -- Function to start live server and open Firefox ESR
        vim.api.nvim_create_user_command("LiveServer", function()
          vim.fn.jobstart("live-server --browser=firefox-esr", { detach = true })
        end, {})

        -- Keybinding to start live server and open in Firefox ESR
        vim.api.nvim_set_keymap("n", "<leader>l", ":LiveServer<CR>", { noremap = true, silent = true })
      end,
    },

    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      config = function()
        require("which-key").setup({})
      end,
    }




  },
  install = { colorscheme = { "tokyonight" } }, -- Ensure it loads on install
  checker = { enabled = true }, -- Auto-check for updates
})
