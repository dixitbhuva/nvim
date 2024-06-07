return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		dependencies = {
			{
				"williamboman/mason-lspconfig.nvim",
				lazy = false,
				opt = { auto_install = true },
			},
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
			require("mason-lspconfig").setup({
				-- list of servers for mason to install
				ensure_installed = {
					"lua_ls",
					"emmet_ls",
				},
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"isort", -- python formatter
					"black", -- python formatter
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- Change the Diagnostic symbols in the sign column (gutter)
			-- (not in youtube nvim video)
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			require("lspconfig").lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						-- make the language server recognize "vim" global
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			require("lspconfig").emmet_ls.setup({
				capabilities = capabilities,
				filetypes = { "html", "css", "sass", "scss", "less" },
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Gives default hover" })
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Jump to definitions" })
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Jump to references" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
		end,
	},
}
