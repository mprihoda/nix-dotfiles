{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      {
        plugin = nvim-metals;
        type = "lua";
        # I have put the whole example nvim-metals config here.
        # TODO: split to multiple configurations by plugin
        # TODO: move to separate file and include
        config = ''
          local g = vim.g
          g.mapleader = ';'
          g.maplocalleader = ','

          local cmd = vim.cmd

          local function map(mode, lhs, rhs, opts)
            local options = { noremap = true }
            if opts then
              options = vim.tbl_extend("force", options, opts)
            end
            vim.api.nvim_set_keymap(mode, lhs, rhs, options)
          end

          -- global
          vim.opt_global.completeopt = { "menu", "noinsert", "noselect" }
          vim.opt_global.shortmess:remove("F"):append("c")

          -- LSP
          map("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>")
          map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
          map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
          map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
          map("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
          map("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
          map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
          map("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
          map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
          map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
          map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]]) -- all workspace diagnostics
          map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
          map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
          map("n", "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<CR>") -- buffer diagnostics only
          map("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
          map("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")
          -- Telescope integration
          map("n", "<leader>mc", [[<cmd>lua require"telescope".extensions.metals.commands()<CR>]])
          map("n", "<leader>ff", [[<cmd>lua require"telescope.builtin".find_files()<CR>]])
          map("n", "<leader>fg", [[<cmd>lua require"telescope.builtin".live_grep()<CR>]])
          map("n", "<leader>fb", [[<cmd>lua require"telescope.builtin".buffers()<CR>]])
          map("n", "<leader>fh", [[<cmd>lua require"telescope.builtin".help_tags()<CR>]])

          -- Example mappings for usage with nvim-dap. If you don't use that, you can
          -- skip these
          map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
          map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
          map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
          map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
          map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
          map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
          map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])

          -- completion related settings
          -- This is similiar to what I use
          local cmp = require("cmp")
          cmp.setup({
            sources = {
              { name = "nvim_lsp" },
              { name = "vsnip" },
            },
            snippet = {
              expand = function(args)
                -- Comes from vsnip
                vim.fn["vsnip#anonymous"](args.body)
              end,
            },
            mapping = {
              -- None of this made sense to me when first looking into this since there
              -- is no vim docs, but you can't have select = true here _unless_ you are
              -- also using the snippet stuff. So keep in mind that if you remove
              -- snippets you need to remove this select
              ["<CR>"] = cmp.mapping.confirm({ select = true }),
              -- I use tabs... some say you should stick to ins-completion
              ["<Tab>"] = function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                else
                  fallback()
                end
              end,
              ["<S-Tab>"] = function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                else
                  fallback()
                end
              end,
            },
          })

          ----------------------------------
          -- COMMANDS ------------------
          ----------------------------------
          -- LSP
          cmd([[augroup lsp]])
          cmd([[autocmd!]])
          cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
          -- NOTE: You may or may not want java included here. You will need it if you want basic Java support
          -- but it may also conflict if you are using something like nvim-jdtls which also works on a java filetype
          -- autocmd.
          cmd([[autocmd FileType java,scala,sbt lua require("metals").initialize_or_attach(metals_config)]])
          cmd([[augroup end]])

          ----------------------------------
          -- LSP Setup ---------------------
          ----------------------------------
          metals_config = require("metals").bare_config()

          -- Example of settings
          metals_config.settings = {
            showImplicitArguments = true,
          --  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
          --  serverVersion = "0.10.9+133-9aae968a-SNAPSHOT",
          }

          -- *READ THIS*
          -- I *highly* recommend setting statusBarProvider to true, however if you do,
          -- you *have* to have a setting to display this in your statusline or else
          -- you'll not see any messages from metals. There is more info in the help
          -- docs about this
          -- metals_config.init_options.statusBarProvider = "on"

          -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

          -- Debug settings if you're using nvim-dap
          local dap = require("dap")

          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "RunOrTest",
              metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
          }

          metals_config.on_attach = function(client, bufnr)
            require("metals").setup_dap()
          end

          -- If you want a :Format command this is useful
          cmd([[command! Format lua vim.lsp.buf.formatting()]])

        '';
      }
      nvim-cmp
      cmp-nvim-lsp
      cmp-vsnip
      cmp-tabnine
      vim-vsnip
      plenary-nvim
      nvim-dap
      vim-nix
      nvim-treesitter
      nvim-treesitter-textobjects
    ];
  };
}
