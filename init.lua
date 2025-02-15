----- Disable perl ruby and python support -----
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

----- Highlight when yanking (copying) text -----
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

----- Bootstrap lazy.nvim -----
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
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

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    { 
      'metalelf0/base16-black-metal-scheme',
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd([[colorscheme base16-black-metal-immortal]])
      end,
    },

    { 
      'nvim-tree/nvim-web-devicons', 
      enabled = vim.g.have_nerd_font
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

    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup({
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗"
            }
          }
        })
      end,
    },

    {
      "williamboman/mason-lspconfig.nvim",
      config = function()
        require("mason-lspconfig").setup {
          ensure_installed = { "lua_ls", "intelephense" },
        }
      end,
    },

    {
      'saghen/blink.cmp',
      dependencies = 'rafamadriz/friendly-snippets',
      version = '*',
      opts = {
        keymap = { preset = 'default' },
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = 'mono'
        },
        signature = { enabled = true },
      }
    },

    {
      'neovim/nvim-lspconfig',
      dependencies = { 'saghen/blink.cmp' },
      -- example using `opts` for defining servers
      opts = {
        servers = {
          lua_ls = {},
          intelephense = {}
        }
      },
      config = function(_, opts)
        local lspconfig = require('lspconfig')
        local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
        for server, config in pairs(opts.servers) do
          -- passing config.capabilities to blink.cmp merges with the capabilities in your
          -- `opts[server].capabilities, if you've defined it
          config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
          config.capabilities = cmp_capabilities
          lspconfig[server].setup(config)
        end
      end
    },

    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip"
      },
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
          }),
        })
      end,
    },

    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
